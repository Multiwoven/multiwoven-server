# frozen_string_literal: true

# == Schema Information
#
# Table name: syncs
#
#  id                :bigint           not null, primary key
#  workspace_id      :integer
#  source_id         :integer
#  model_id          :integer
#  destination_id    :integer
#  configuration     :jsonb
#  source_catalog_id :integer
#  schedule_type     :integer
#  schedule_data     :jsonb
#  status            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "rails_helper"

RSpec.describe Sync, type: :model do
  it { should validate_presence_of(:workspace_id) }
  it { should validate_presence_of(:source_id) }
  it { should validate_presence_of(:destination_id) }
  it { should validate_presence_of(:model_id) }
  it { should validate_presence_of(:configuration) }
  it { should validate_presence_of(:schedule_type) }
  it { should validate_presence_of(:schedule_data) }
  it { should validate_presence_of(:status) }

  it { should define_enum_for(:schedule_type).with_values(manual: 0, automated: 1) }
  it { should define_enum_for(:status).with_values(healthy: 0, failed: 1, aborted: 2, in_progress: 3, disabled: 4) }

  it { should belong_to(:workspace) }
  it { should belong_to(:source).class_name("Connector") }
  it { should belong_to(:destination).class_name("Connector") }
  it { should belong_to(:model) }
end
