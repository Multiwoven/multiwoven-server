# frozen_string_literal: true

require "rails_helper"

RSpec.describe Connectors::DiscoverConnector, type: :interactor do
  describe "#call" do
    let(:connector) { create(:connector) }
    let(:connector_client) { double("ConnectorClient") }
    let(:streams) { "stream_test_data" }

    before do
      allow(Multiwoven::Integrations::Service).to receive_message_chain(:connector_class,
                                                                        :new).and_return(connector_client)
      allow(connector_client).to receive_message_chain(:discover, :catalog, :to_json).and_return(streams)
    end

    context "when catalog is already present" do
      it "returns existing catalog" do
        catalog = create(:catalog, connector:)
        result = described_class.call(connector:)
        expect(result.catalog).to eq(catalog)
      end
    end

    context "when catalog is not present" do
      it "create catalog" do
        expect(connector.catalog).to eq(nil)
        result = described_class.call(connector:)
        expect(connector.reload.catalog).not_to eq(nil)
        expect(result.success?).to eq(true)
      end
    end
  end
end
