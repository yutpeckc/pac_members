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
    column :jr_member
    column :created_at
    column :updated_at
    actions
  end

  collection_action :cancel_sub do
    u = User.find(params[:id])
    if u.cancel_subscription
      redirect_to admin_users_path, notice: "Subscription Cancelled!"
    else
      redirect_to admin_user_path(id: params[:id]), error: "There was an error cancelling the subscription"
    end
  end  

  action_item :cancel_subscription, only: :show do
    link_to 'Cancel Subscription', cancel_sub_admin_users_path(id: params[:id]), data: { confirm: "Are you sure?" }
  end  

  filter :email
  filter :first_name
  filter :last_name
  filter :auto_renew  
  filter :membership_expiration
  filter :plan_id
  filter :created_at

  form do |f|
    panel 'Instructions' do
      %(To CREATE a User: a new user you only *need* to enter their email, first and last name, expiration, and plan_id. The system will generate a random password. Remember - the membership expiration is 1 YEAR after they joined.

        To EDIT a User: You can edit pretty much everything and anything, but can change one thing at a time (no need to enter passwords either!)

        #{params.inspect} 
        )
    end    
    f.inputs "User Details" do
      f.input :email
      f.input :password, required: false
      f.input :password_confirmation, required: false
      f.input :membership_expiration, required: true
      f.input :plan, required: true
      f.input :jr_member
      f.input :first_name
      f.input :last_name
      f.input :phone_number
      f.input :street_address
      f.input :city
      f.input :province
      f.input :country, priority_countries: ["Canada"]
      f.input :postal_code
    end
    f.actions
  end

  controller do

    def create
      u = params[:user]
      if u["membership_expiration(1i)"] == "" || u["membership_expiration(2i)"] == "" || u["membership_expiration(3i)"] == ""
        flash[:error] = "You must use a valid membership expiration date"
        redirect_to :back
      elsif u[:plan_id].nil?
        flash[:error] = "You must give the user a plan"
        redirect_to :back
      else
        pwd = User.random_md5_pwd
        u[:password] = pwd
        u[:password_confirmation] = pwd
        super
        if @user.id.present?
          # if it saves then send the email!
          um = UserMailer.new
          um.created_account(@user,pwd)
        end
      end
    end
    def permitted_params
      params.permit user: [:email, :password, :password_confirmation, :membership_expiration, :plan, :plan_id, :first_name,:last_name, :phone_number, :street_address, :city, :province, :country, :postal_code, :jr_member]
    end    
  end  

end
