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

  collection_action :invite_jr do
  end 

  collection_action :invite_jr, method: :post do
  end

  action_item :cancel_subscription, only: :show do
    link_to 'Cancel Subscription', cancel_sub_admin_users_path(id: params[:id]), data: { confirm: "Are you sure?" }
  end  

  action_item :invite_jr, only: :index do
    link_to "Invite Jr Member", invite_jr_admin_users_path
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
      para "To CREATE a User ---> For a new user you only *need* to enter their email, first and last name, expiration, and plan_id. The system will generate a random password. Remember - the membership expiration is 1 YEAR after they joined."
      para "----------------"
      para "To EDIT a User ---> You can edit pretty much everything and anything, but can change one thing at a time (no need to enter passwords either!)"      
      para "----------------"
      para "To GRANDFATHER a User onto an old plan ---> You can do one of two things. You can create a user (like it says above), or have them sign up and stop before they're about to pay. Then, go in and edit their user account: add the plan_id for the appropriate plan, and set the expiration date to any time in the past. They should see the old plan when they log in now."       
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

    def invite_jr
      if params[:user_email].present?
        u = User.new
        
        u.email = params[:user_email]
        u.first_name = params[:first_name]
        u.last_name = params[:last_name]
        u.jr_member = true
        
        pwd = User.random_md5_pwd
        u.password = pwd
        u.password_confirmation = pwd

        if u.save
          um = UserMailer.new
          um.jr_account_created(u,pwd)
          redirect_to admin_users_path, notice: "User Invited!"
        else
          redirect_to admin_users_path, alert: "Error inviting user"
        end
      end
    end

    def permitted_params
      params.permit user: [:email, :password, :password_confirmation, :membership_expiration, :plan, :plan_id, :first_name,:last_name, :phone_number, :street_address, :city, :province, :country, :postal_code, :jr_member]
    end    
  end  

end
