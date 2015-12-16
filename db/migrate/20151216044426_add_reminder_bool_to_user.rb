class AddReminderBoolToUser < ActiveRecord::Migration
  def change
    add_column :users, :dont_remind, :boolean, default: false
  end
end
