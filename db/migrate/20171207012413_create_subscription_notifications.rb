class CreateSubscriptionNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_notifications do |t|
      t.string :name, null: false
      t.string :key, null: false
      t.boolean :auto_subscribe, default: false

      t.timestamps
    end
    add_index :subscription_notifications, :key
  end
end
