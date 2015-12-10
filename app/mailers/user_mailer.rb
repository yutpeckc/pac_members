class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = User.find user.id
    @url = password_reset_url(@user.reset_password_token)
    mail(:to => user.email,
    	:subject => "Your Pacific Club password has been reset")
  end

  def two_week_reminder_renewing(user)
    @user = user
    mail(:to => user.email,
      :subject => "Your Pacific Club Membershp is renewing soon")    
  end

  def two_week_reminder_non_renewing(user)
    @user = user
    mail(:to => user.email,
      :subject => "Your Pacific Club Membership is expiring soon")    
  end

  def expiration_notice(user)
    @user = user
    mail(:to => user.email,
      :subject => "Your Pacific Club Membership has expired")
  end

  def created_account(user,pwd)
    @user = user
    @pwd = pwd
    mail(:to => user.email,
      :subject => "Your Pacific Club Membership Login Details")
  end

end
