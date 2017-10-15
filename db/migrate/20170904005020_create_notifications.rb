class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :user_id, null: false
      t.string :notifiable_type
      t.integer :notifiable_id
      t.string :title
      t.string :summary
      t.string :url
      t.string :category
      t.boolean :admin, default: false
      t.datetime :expires_at
      t.boolean :read, default: false
      t.timestamps null: false
    end
    add_index :notifications, :read
    add_index :notifications, :user_id
    add_index :notifications, [:notifiable_type, :notifiable_id]
  end
end
