class ChangeGenderToBeStringInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :gender, :string
  end
end
