class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login, :require_contact_info

  private
  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end  

  def require_contact_info
    if logged_in? && current_user.contact_info_empty?
      redirect_to contact_info_path, notice: "Please update your contact info before continuing"
    end
  end
end