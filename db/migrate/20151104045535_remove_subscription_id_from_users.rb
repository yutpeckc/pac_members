class RemoveSubscriptionIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :subscription_id
  end
end
