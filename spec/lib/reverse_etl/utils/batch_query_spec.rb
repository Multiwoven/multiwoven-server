# frozen_string_literal: true

require "rails_helper"

module ReverseEtl
  module Utils
    RSpec.describe BatchQuery do
      describe ".execute_in_batches" do
        let(:client) { double("Client") }

        let(:destination) { create(:connector, connector_type: "destination") }
        let!(:catalog) { create(:catalog, connector: destination) }

        let(:sync) { create(:sync, destination:) }

        before do
          allow(client).to receive(:execute) { |config| Array.new(config.limit, "mock_data") }
        end

        it "executes batches correctly" do
          params = {
            offset: 0,
            limit: 100,
            batch_size: 10,
            sync_config: sync.to_protocol,
            client:
          }

          expect(client).to receive(:execute).exactly(10).times

          results = []
          BatchQuery.execute_in_batches(params) do |result|
            results << result
          end

          expect(results.size).to eq(10)
          expect(results.first.size).to eq(10)
          expect(results.last.size).to eq(10)
        end
      end
    end
  end
end
