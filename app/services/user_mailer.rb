class UserMailer
  # uses SendGrid

  def initialize
    @host = Rails.application.config.action_mailer.default_url_options[:host]
  end

  def reset_password_email(user)
    user.generate_reset_password_token!

    url = Rails.application.routes.url_helpers.password_reset_url(user.reset_password_token, host: @host)

    subject = "Your Pacific Club password has been reset"
    text = %(Hey #{user.first_name}

    You have requested to reset your password.

    To choose a new password, just follow this link: #{url}.

    Have a great day!

    The Pacific Club Team
    )
    
    send_mail(user.email, subject, text)    
  end

  def two_week_reminder_renewing(user)
    subject = "Your Pacific Club Membershp is renewing soon"
    expiration = user.membership_expiration.strftime("%B #{user.membership_expiration.day.ordinalize}, %Y")
    text = %(Hey #{user.first_name},

    This is just a friendly reminder that your membership will automatically renew on #{expiration}. Don't worry - you don't need to do anything! Just sit back, relax, and keep an eye on your inbox for the receipt.

    If you don't want to renew your membership just reply to this email and let us know.

    Thanks!

    The Pacific Club    
    )
    
    send_mail(user.email, subject, text)
  end

  def two_week_reminder_non_renewing(user)
    subject = "Your Pacific Club Membership is expiring soon"
    expiration = user.membership_expiration.strftime("%B #{user.membership_expiration.day.ordinalize}, %Y")
    text = %(Hey #{user.first_name},

    This is just a friendly reminder that your membership is set to expire on #{expiration}. You don't need to do anything right now - we just wanted to let you know ahead of time. 

    When your membership does expire we'll send you an email with instructions on how to renew. 

    Thanks!

    The Pacific Club    
    )
    
    send_mail(user.email, subject, text)           
  end

  def expiration_notice(user)
    subject = "Your Pacific Club Membership has expired"
    renew_path = Rails.application.routes.url_helpers.renew_url(host: @host)
    text = %(Hey #{user.first_name},

    It seems like your membership has expired! To renew just follow this link #{renew_path}. 

    If you have any questions just reply to this email.

    Have a great day!

    The Pacific Club
    )
    
    send_mail(user.email, subject, text, "rita@viralogix.ca")
  end

  def created_account(user,pwd)
    subject = "Your Pacific Club Membership Login Details"
    text = %(Hey #{user.first_name},

    This is just to let you know that we've created an account for you on the new membership section of our website. Right now it's just being used for billing info, but we're hoping to expand on that soon!

    We've created a random password for you, but suggest you log in and change it ASAP. To do so, visit http://members.thepacificclub.com/login and use these credentials:

    Email: #{user.email}
    Password: #{pwd}

    If you have any questions just let us know. Thanks!

    The Pacific Club
    )
    
    send_mail(user.email, subject, text)
  end

  def send_event_code(user,event_name,code,event_url)
    subject = "Your event code for #{event_name} with the Pacific Club"
    text = %(Hey #{user.first_name},

    Below is your personal coupon code for our next event. If you haven't already heard about it you can read more about it here: #{url}

    When you reserve your ticket make sure to use the code below to get it free.

    Code: #{code.email}

    If you have any questions just let us know. Thanks!

    The Pacific Club
    )
    
    send_mail(user.email, subject, text)
  end

  def send_mail(to,subject,text, cc = nil)
    client = SendGrid::Client.new(api_user: ENV['SENDGRID_USERNAME'], api_key: ENV['SENDGRID_PASSWORD'])
    mail = SendGrid::Mail.new do |m|
      m.to = to
      m.from = "thepacificclub@gmail.com"
      m.from_name = "The Pacific Club"
      m.subject = subject
      m.text = text
      m.cc = cc
    end
    puts mail.inspect
    res = client.send(mail)
    puts res.body
  end
end
