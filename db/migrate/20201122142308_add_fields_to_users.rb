class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :birthdate, :date
    add_column :users, :gender, :integer
  end
end
