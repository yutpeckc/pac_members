class AddUserDetails < ActiveRecord::Migration
  def change
  	add_column :users, :stripe_customer_id, :string
  	add_column :users, :membership_expiration, :datetime
  	add_column :users, :auto_renew, :bool
  	add_column :users, :subscription_id, :string
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  end
end
