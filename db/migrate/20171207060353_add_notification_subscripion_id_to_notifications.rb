class AddNotificationSubscripionIdToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :subscription_notification_id, :integer
    add_index :notifications, :subscription_notification_id
  end
end
