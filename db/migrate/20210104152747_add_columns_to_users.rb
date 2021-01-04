class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bio, :string, limit: 101
    add_column :users, :workplace, :string
    add_column :users, :hometown, :string
    add_column :users, :relationship_status, :string
    add_column :users, :hobbies, :string, limit: 101
  end
end
