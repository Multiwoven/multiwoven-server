# frozen_string_literal: true

module Activities
  class ExtractorActivity < Temporal::Activity
    timeouts(
      start_to_close: (ENV["TEMPORAL_ACTIVITY_START_TO_CLOSE_IN_SEC"] || "172800").to_i,
      heartbeat: (ENV["TEMPORAL_ACTIVITY_HEARTBEAT_TIMEOUT_IN_SEC"] || "120").to_i
    )

    retry_policy(
      interval: (ENV["TEMPORAL_ACTIVITY_RETRY_INTERVAL_IN_SEC"] || "1").to_i,
      backoff: (ENV["TEMPORAL_ACTIVITY_RETRY_BACK_OFF"] || "1").to_i,
      max_attempts: (ENV["TEMPORAL_ACTIVITY_RETRY_MAX_ATTEMPT"] || "3").to_i
      # non_retriable_errors: [SyncRunStateExeption]
    )

    def execute(sync_run_id)
      sync_run = SyncRun.find(sync_run_id)

      unless sync_run.may_start?
        Temporal.logger.error(error_message: "SyncRun cannot start from its current state: #{sync_run.status}",
                              sync_run_id: sync_run.id,
                              stack_trace: nil)
        return
      end

      # state of sync run to started only if current stete in [ pending,started,querying]
      sync_run.start
      sync_run.update(started_at: Time.zone.now)

      # TODO: Select extraction strategy
      # based on sync mode eg: incremental/full_refresh
      extractor = ReverseEtl::Extractors::IncrementalDelta.new
      extractor.read(sync_run.id, activity)
    end
  end
end
