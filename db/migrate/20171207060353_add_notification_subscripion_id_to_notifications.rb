class AddNotificationSubscripionIdToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :notification_subscripion_id, :integer
    add_index :notifications, :notification_subscripion_id
  end
end
