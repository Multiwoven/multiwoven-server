# frozen_string_literal: true

module Activities
  class ReporterActivity < Temporal::Activity
    def execute(sync_run_id)
      sync_run = SyncRun.find(sync_run_id)

      return unless sync_run.may_complete?

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
  end
end
