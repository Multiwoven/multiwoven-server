# frozen_string_literal: true

module Activities
  class LoaderActivity < Temporal::Activity
    timeouts(
      start_to_close: (ENV["TEMPORAL_ACTIVITY_START_TO_CLOSE"] || "172800").to_i,
      heartbeat: (ENV["TEMPORAL_ACTIVITY_HEARTBEAT_TIMEOUT"] || "120").to_i
    )
    retry_policy(
      interval: (ENV["TEMPORAL_ACTIVITY_RETRY_INTERVAL"] || "1").to_i,
      backoff: (ENV["TEMPORAL_ACTIVITY_RETRY_BACK_OFF"] || "1").to_i,
      max_attempts: (ENV["TEMPORAL_ACTIVITY_RETRY_MAX_ATTEMPT"] || "3").to_i
      # TODO: non_retriable_errors
      # non_retriable_errors: [TerminalGuess]
    )
    def execute(sync_run_id)
      # TODO: Select loader strategy
      # based on destination sync mode
      loader = ReverseEtl::Loaders::Standard.new
      loader.write(sync_run_id, activity)
    end
  end
end
