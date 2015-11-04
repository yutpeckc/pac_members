class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :plan_stripe_id
      t.boolean :active
      t.integer :price
      t.string :name

      t.timestamps null: false
    end
  end
end
