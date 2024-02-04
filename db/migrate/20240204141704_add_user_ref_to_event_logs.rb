class AddUserRefToEventLogs < ActiveRecord::Migration[7.1]
  def change
    add_reference :event_logs, :user, foreign_key: true
  end
end
