# frozen_string_literal: true

module Workflows
  class SyncWorkflow < Temporal::Workflow
    include Activities
    def execute
      puts "start: SyncWorkflow.execute"
      Activities::ExtractorActivity.execute
      Activities::LoaderActivity.execute
      Activities::ReporterActivity.execute
      puts "end: SyncWorkflow.execute"
    end
  end
end
