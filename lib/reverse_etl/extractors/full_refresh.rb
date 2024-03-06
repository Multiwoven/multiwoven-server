# frozen_string_literal: true

module ReverseEtl
  module Extractors
    class FullRefresh < Base
      def read(sync_run_id, activity)
        total_query_rows = 0
        sync_run = SyncRun.find(sync_run_id)

        return log_error(sync_run) unless sync_run.may_query?

        sync_run.query!

        source_client = setup_source_client(sync_run.sync)

        batch_query_params = batch_params(source_client, sync_run)
        model = sync_run.sync.model

        sync_run.sync_records.delete_all

        ReverseEtl::Utils::BatchQuery.execute_in_batches(batch_query_params) do |records, current_offset|
          total_query_rows += records.count
          process_records(records, sync_run, model)
          heartbeat(activity)
          sync_run.update(current_offset:, total_query_rows:)
        end

        # change state querying to queued
        sync_run.queue!
      end

      private

      def process_records(records, sync_run, model)
        sync_records_to_save = Parallel.map(records, in_threads: THREAD_COUNT) do |message|
          build_sync_record(message, sync_run, model)
          # Use .compact to remove any nil items that might have been added due to errors
        end.compact

        unless sync_records_to_save.empty?
          byebug
          result = SyncRecord.insert_all(sync_records_to_save, # rubocop:disable Rails/SkipsModelValidations
                                         returning: %w[primary_key])
          valid_primary_keys = result.rows.flatten

          if sync_records_to_save.count != valid_primary_keys.count
            error_message = "Mismatch in record count. Expected: #{sync_records_to_save.count}, Successfully Inserted:
             #{valid_primary_keys.count}"
            Temporal.logger.error(
              error_message:,
              sync_run_id: sync_run.id
            )
          end
        end
      rescue StandardError => e
        Temporal.logger.error(error_message: e.message,
                              sync_run_id: sync_run.id,
                              stack_trace: Rails.backtrace_cleaner.clean(e.backtrace))
      end

      def build_sync_record(message, sync_run, model)
        record = message.record
        primary_key = record.data.with_indifferent_access[model.primary_key]

        sync_run.sync_records.new(
          sync_id: sync_run.sync_id,
          primary_key:,
          created_at: DateTime.current,
          sync_run_id: sync_run.id,
          action: destination_insert,
          fingerprint: generate_fingerprint(record.data),
          record: record.data
        )
      rescue StandardError => e
        Temporal.logger.error(error_message: e.message,
                              sync_run_id: sync_run.id,
                              stack_trace: Rails.backtrace_cleaner.clean(e.backtrace))
      end
    end
  end
end
