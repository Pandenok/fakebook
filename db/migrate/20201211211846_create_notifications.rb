class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :sent_to_id
      t.integer :sent_by_id
      t.string :status, default: "Unseen"
      t.string :action
      t.integer :notifiable_id
      t.string :notifiable_type

      t.timestamps
    end
  end
end
