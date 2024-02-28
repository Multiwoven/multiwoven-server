# frozen_string_literal: true

module ReverseEtl
  module Extractors
    class IncrementalDelta < Base
      THREAD_COUNT = (ENV["SYNC_EXTRACTOR_THREAD_POOL_SIZE"] || "5").to_i

      # TODO: Make it as class method
      def read(sync_run_id, activity)
        total_query_count = 0
        sync_run = setup_sync_run(sync_run_id)
        source_client = setup_source_client(sync_run.sync)

        batch_query_params = batch_params(source_client, sync_run)
        model = sync_run.sync.model

        ReverseEtl::Utils::BatchQuery.execute_in_batches(batch_query_params) do |records, current_offset|
          total_query_count += records.count
          process_records(records, sync_run, model)
          heartbeat(activity)
          sync_run.update(current_offset:)
        end
      end

      private

      def heartbeat(activity)
        activity.heartbeat
        raise StandardError, "Cancel activity request received" if activity.cancel_requested
      end

      def setup_sync_run(sync_run_id)
        SyncRun.find(sync_run_id).tap do |sync_run|
          sync_run.update(status: :in_progress, started_at: DateTime.now)
        end
      end

      def setup_source_client(sync)
        sync.source.connector_client.new
      end

      def process_records(records, sync_run, model)
        # TODO: parellelize this
        Parallel.each(records, in_threads: THREAD_COUNT) do |message|
          process_record(message, sync_run, model)
        end
      end

      def process_record(message, sync_run, model)
        record = message.record
        fingerprint = generate_fingerprint(record.data)
        primary_key = record.data.with_indifferent_access[model.primary_key]

        sync_record = find_or_initialize_sync_record(sync_run, primary_key)
        update_or_create_sync_record(sync_record, record, sync_run, fingerprint)
      rescue StandardError => e
        Temporal.logger.error(error_message: e.message,
                              sync_run_id: sync_run.id,
                              stack_trace: Rails.backtrace_cleaner.clean(e.backtrace))
      end

      def generate_fingerprint(data)
        Digest::SHA1.hexdigest(data.to_json)
      end

      def find_or_initialize_sync_record(sync_run, primary_key)
        SyncRecord.find_by(sync_id: sync_run.sync_id, primary_key:) ||
          sync_run.sync_records.new(sync_id: sync_run.sync_id, primary_key:, created_at: DateTime.current)
      end

      def new_record?(sync_record, fingerprint)
        sync_record.new_record? || sync_record.fingerprint != fingerprint
      end

      def action(sync_record)
        sync_record.new_record? ? :destination_insert : :destination_update
      end

      def update_or_create_sync_record(sync_record, record, sync_run, fingerprint)
        return unless new_record?(sync_record, fingerprint)

        sync_record.assign_attributes(
          sync_run_id: sync_run.id,
          action: action(sync_record),
          fingerprint:,
          record: record.data
        )
        sync_record.save!
      end
    end
  end
end
