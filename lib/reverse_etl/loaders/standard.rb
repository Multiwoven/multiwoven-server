# frozen_string_literal: true

module ReverseEtl
  module Loaders
    class Standard < Base
      def write(sync_run_id)
        sync_run = SyncRun.find(sync_run_id)
        sync = sync_run.sync
        sync_config = sync.to_protocol

        transformer = Transformers::UserMapping.new
        client = sync.destination.connector_client.new

        sync_run.sync_records.find_in_batches do |sync_records|
          sync_records.each do |sync_record|
            record = transformer.transform(sync, sync_record)
            # puts record
            report = client.write(sync_config, [record])
            # Multiwoven::Integrations::Destination::Klaviyo::Client
            puts report
          rescue StandardError => e
            byebug
            Rails.logger(e)
          end
        end
      end
    end
  end
end
