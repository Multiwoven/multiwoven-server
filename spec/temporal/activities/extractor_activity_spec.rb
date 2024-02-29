# frozen_string_literal: true

require "rails_helper"

RSpec.describe Activities::ExtractorActivity do
  describe "#execute" do
    let(:source) do
      create(:connector, connector_type: "source", connector_name: "Snowflake")
    end
    let(:destination) { create(:connector, connector_type: "destination") }
    let!(:catalog) { create(:catalog, connector: destination) }
    let!(:sync) { create(:sync, sync_interval: 3, sync_interval_unit: "hours", source:, destination:) }
    let(:sync_run) { create(:sync_run, sync:, workspace: sync.workspace, source:, destination:, model: sync.model) }
    let(:sync_run_satrted) do
      create(:sync_run, sync:, workspace: sync.workspace, source:, destination:, model: sync.model, status: "started")
    end
    let(:sync_run_querying) do
      create(:sync_run, sync:, workspace: sync.workspace, source:, destination:, model: sync.model, status: "querying")
    end
    let(:sync_run_queued) do
      create(:sync_run, sync:, workspace: sync.workspace, source:, destination:, model: sync.model, status: "queued")
    end
    let(:extractor_instance) { instance_double("ReverseEtl::Extractors::IncrementalDelta") }
    let(:mock_context) { double("context") }
    let(:activity) { Activities::ExtractorActivity.new(mock_context) }

    before do
      allow(ReverseEtl::Extractors::IncrementalDelta).to receive(:new).and_return(extractor_instance)
      allow(extractor_instance).to receive(:read).with(anything, mock_context)
    end

    it "sync run pending to started" do
      expect(sync_run).to have_state(:pending)
      activity.execute(sync_run.id)
      sync_run_after = SyncRun.find(sync_run.id)
      expect(sync_run_after).to have_state(:started)
      expect(sync_run_after.sync_id).to eq(sync.id)
      expect(sync_run_after.workspace_id).to eq(sync.workspace_id)
      expect(sync_run_after.source_id).to eq(sync.source_id)
      expect(sync_run_after.destination_id).to eq(sync.destination_id)
      expect(sync_run_after.model_id).to eq(sync.model_id)
    end

    it "sync run started to started" do
      expect(sync_run_satrted).to have_state(:started)
      activity.execute(sync_run_satrted.id)
      sync_run_after = SyncRun.find(sync_run_satrted.id)
      expect(sync_run_after).to have_state(:started)
      expect(sync_run_after.sync_id).to eq(sync.id)
      expect(sync_run_after.workspace_id).to eq(sync.workspace_id)
      expect(sync_run_after.source_id).to eq(sync.source_id)
      expect(sync_run_after.destination_id).to eq(sync.destination_id)
      expect(sync_run_after.model_id).to eq(sync.model_id)
    end

    it "sync run querying to started" do
      expect(sync_run_querying).to have_state(:querying)
      activity.execute(sync_run_querying.id)
      sync_run_after = SyncRun.find(sync_run_querying.id)
      expect(sync_run_after).to have_state(:started)
      expect(sync_run_after.sync_id).to eq(sync.id)
      expect(sync_run_after.workspace_id).to eq(sync.workspace_id)
      expect(sync_run_after.source_id).to eq(sync.source_id)
      expect(sync_run_after.destination_id).to eq(sync.destination_id)
      expect(sync_run_after.model_id).to eq(sync.model_id)
    end

    context "when sync run may not start" do
      it "trying to queued to start" do
        expect(sync_run_queued).to have_state(:queued)

        expect do
          activity.execute(sync_run_queued.id)
        end.to raise_error(Activities::ExtractorActivity::SyncRunStateExeption)
        sync_run_after = SyncRun.find(sync_run_queued.id)
        expect(sync_run_after).to have_state(:failed)
        expect(sync_run_after.sync).to have_state(:failed)
      end
    end
  end
end
