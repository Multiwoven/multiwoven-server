require "rails_helper"

RSpec.describe SyncRun, type: :model do
  it { should validate_presence_of(:sync_id) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:started_at) }
  it { should validate_presence_of(:finished_at) }
  it { should validate_presence_of(:total_rows) }
  it { should validate_presence_of(:successful_rows) }
  it { should validate_presence_of(:failed_rows) }

  it { should belong_to(:sync) }

  describe "enum for status" do
    it { should define_enum_for(:status).with_values(%i[success failed in_progress incomplete]) }
  end
end
