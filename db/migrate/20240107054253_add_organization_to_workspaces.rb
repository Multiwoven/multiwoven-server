class AddOrganizationToWorkspaces < ActiveRecord::Migration[7.1]
  def change
    add_reference :workspaces, :organization, null: false, foreign_key: true
  end
end
