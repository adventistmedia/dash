class CreateAdminNotification < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_notifications do |t|
      t.string :owner_type
      t.integer :owner_id
      t.string :user_scope
      t.string :title
      t.string :summary
      t.string :url
      t.date :expires_at
      t.timestamps
    end
    add_index :admin_notifications, [:owner_type, :owner_id]
  end
end
