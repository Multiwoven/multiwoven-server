# frozen_string_literal: true

module ReverseEtl
  module Loaders
    class Standard < Base
      THREAD_COUNT = 5
      def write(sync_run_id)
        sync_run = SyncRun.find(sync_run_id)
        sync = sync_run.sync
        sync_config = sync.to_protocol

        transformer = Transformers::UserMapping.new
        client = sync.destination.connector_client.new

        # TODO: Fetch only records with status pending
        sync_run.sync_records.find_in_batches do |sync_records|
          Parallel.each(sync_records, in_threads: THREAD_COUNT) do |sync_record|
            record = transformer.transform(sync, sync_record)
            report = client.write(sync_config, [record])
            # TODO: Update status of sync recrod using IN query
            # if 100% of the batch failed then save the error also to the sync run
            puts report
          rescue StandardError => e
            Rails.logger(e)
          end
        end
      end
    end
  end
end
