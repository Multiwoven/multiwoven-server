# frozen_string_literal: true

module Activities
  class ReporterActivity < Temporal::Activity
    def execute(sync_run_id)
      sync_run = SyncRun.find(sync_run_id)

      unless sync_run.may_complete?
        update_failure(sync_run)
        raise StandardError,
              "SyncRun cannot transition to 'success' from its current state: #{sync_run.status}"
      end

      update_sucess(sync_run)

      total_rows, successful_rows, failed_rows = fetch_record_counts(sync_run)

      sync_run.update!(
        finished_at: Time.zone.now,
        total_rows:,
        successful_rows:,
        failed_rows:
      )
    end

    private

    def fetch_record_counts(sync_run)
      total = sync_run.sync_records.count
      success = sync_run.sync_records.success.count
      failed = sync_run.sync_records.failed.count
      [total, success, failed]
    end

    def update_sucess(sync_run)
      sync_run.complete!
      sync = sync_run.sync
      sync.complete!
    end

    def update_failure(sync_run)
      sync_run.abort!
      sync = sync_run.sync
      sync.fail!
    end
  end
end
