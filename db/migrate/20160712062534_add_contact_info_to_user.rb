class AddContactInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :adress, :string
    add_column :users, :phone_number, :string
  end
end
