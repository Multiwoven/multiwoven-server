require "rails_helper"

RSpec.describe ReverseEtl::Extractors::IncrementalDelta do
  let(:source) do
    create(:connector, connector_type: "source", connector_name: "Snowflake")
  end
  let(:destination) { create(:connector, connector_type: "destination") }
  let!(:catalog) { create(:catalog, connector: destination) }
  let(:sync) { create(:sync, source:, destination:) }
  let(:sync_run) { create(:sync_run, sync:) }

  let(:client) { Multiwoven::Integrations::Source::Snowflake::Client.new }
  let(:record1) do
    Multiwoven::Integrations::Protocol::RecordMessage.new(data: { id: 1 },
                                                          emitted_at: DateTime.now.to_i).to_multiwoven_message
  end
  let(:record2) do
    Multiwoven::Integrations::Protocol::RecordMessage.new(data: { id: 2 },
                                                          emitted_at: DateTime.now.to_i).to_multiwoven_message
  end

  let(:records) { [record1, record2] }

  before do
    allow(client).to receive(:read).and_return(records)
    allow(ReverseEtl::Utils::BatchQuery).to receive(:execute_in_batches).and_yield(records)
    allow(sync_run.sync.source).to receive_message_chain(:connector_client, :new).and_return(client)
  end

  describe "#read" do
    context "when there is a new record" do
      it "creates a new sync record" do
        expect { subject.read(sync_run.id) }.to change(sync_run.sync_records, :count).by(2)
      end
    end
  end

  xcontext "when an existing record is updated" do
    it "updates the existing sync record" do
      # First read to create initial records
      subject.read(sync_run.id)
      expect { sync_run.sync_records.count }.to eq(2)

      sync_record1 = sync_run.sync_records.first
      sync_record2 = sync_run.sync_records.last

      # Modify record1 and read again
    end
  end
end
