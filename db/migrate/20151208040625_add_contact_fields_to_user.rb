class AddContactFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :street_address, :string
    add_column :users, :city, :string
    add_column :users, :province, :string
    add_column :users, :country, :string
    add_column :users, :postal_code, :string
  end
end
