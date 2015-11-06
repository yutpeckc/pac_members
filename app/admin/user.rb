ActiveAdmin.register User do

  permit_params :email, :password, :password_confirmation, :membership_expiration, :plan_id, :created_at

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :auto_renew
    column :membership_expiration
    column :plan_id
    column :created_at
    column :updated_at
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :auto_renew  
  filter :membership_expiration
  filter :plan_id
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :membership_expiration
      f.input :plan_id
      f.input :created_at
    end
    f.actions
  end


end
