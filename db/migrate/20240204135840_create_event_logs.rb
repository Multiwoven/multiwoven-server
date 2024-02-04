class CreateEventLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :event_logs do |t|
      t.string :event_name
      t.jsonb :properties
      t.references :organization, null: false, foreign_key: true
      t.references :workspace, null: false, foreign_key: true

      t.timestamps
    end
  end
end
