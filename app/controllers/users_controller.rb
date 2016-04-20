class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :contact_info, :contact_info_update]
  skip_before_filter :require_login, only: [:index, :new, :create]

  # GET /users/new
  def new
    unless logged_in?
      @user = User.new
    else
      redirect_to subscribe_path
    end
  end

  # GET /users/1/edit
  def edit
    @pwd_text = "Password (required)"
    @pwd_conf_text = "Password Confirmation (required)"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        auto_login(@user)
        # flash[:success] = "You are successfully logged in!"
        # redirect_to @user
        # redirect_to(:users, notice: 'User was successfully created')
        m = Mailchimp.new
        m.add_user(@user)

        format.html { redirect_to subscribe_path}
        # format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    different_email = (@user.email != user_params["email"] ? true : false)
    old_email = @user.email

    if @user.update(user_params)
      if different_email
        m = Mailchimp.new
        m.change_email(old_email,@user.email)
      end
      redirect_to :user, notice: 'Updated - thanks!.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def contact_info

  end

  def contact_info_update
    if @user.update(user_params) 
      if @user.stripe_customer_id.nil? || (@user.membership_expiration < Time.now)
        redirect_to subscribe_path
      else
        redirect_to contact_info_path, notice: 'Updated - thanks!'
      end
    else
      render :contact_info
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      # @user = User.find(params[:id])
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone_number, :street_address, :city, :country, :province, :postal_code)
    end


end
