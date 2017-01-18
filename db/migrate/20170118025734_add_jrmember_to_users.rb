class AddJrmemberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :jr_member, :boolean, default: false
  end
end
