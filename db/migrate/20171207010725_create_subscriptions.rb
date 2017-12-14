class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :subscription_notification_id
      t.integer :subscribed_by_id

      t.timestamps
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :subscription_notification_id
  end
end
