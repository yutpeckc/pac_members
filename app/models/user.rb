class User < ActiveRecord::Base
	authenticates_with_sorcery!

	validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
	validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
	validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }
  validates :first_name, presence: true
  validates :last_name, presence: true

	validates :email, uniqueness: true, presence: true

  belongs_to :plan

  def self.scan_for_expirations
    um = UserMailer.new

    all.each do |u|
      if u.membership_expiration < 2.weeks.from_now && u.auto_renew && !dont_remind
        #subscriber about to renew
        um.two_week_reminder_renewing(u).deliver_now
      elsif u.membership_expiration < 2.weeks.from_now && !u.auto_renew
        #non subscriber that needs to renew
        um.two_week_reminder_non_renewing(u).deliver_now
      elsif u.membership_expiration < Time.now && !u.auto_renew
        #member who has expired either way
        um.expiration_notice(u).deliver_now
        m = Mailchimp.new
        m.change_membership(u,"expired")
      elsif u.membership_expiration < Time.now && u.auto_renew && !u.dont_remind
        #member has rolled over and needs to have expiration date moved out
        expiration = u.membership_expiration + 1.year
        u.update(membership_expiration: expiration)
      end
    end
  end

  def self.random_md5_pwd
    SecureRandom.urlsafe_base64(5)
  end

  def contact_info_empty?
    return true if phone_number.nil?
    return true if street_address.nil?
    return true if city.nil?
    return true if province.nil?
    return true if country.nil?
    return true if postal_code.nil?
  end

  def cancel_subscription
    if auto_renew
      #cancel on stripe, proceed if it works
      if false#StripeService.cancel_subscription(self)    
        #update mailchimp membership
        m = Mailchimp.new
        m.change_membership(self,"canceled")
        #turn off auto-renew
        #add "do not remind" flag if cancelled
        #chosen to assume that if they go out of their way to ask us to cancel, that they really don't want to be a part of this anymore and would not appreciate additional emails
        opts = {auto_renew: false, dont_remind: true}
        if update(opts)
          return true
        else
          return false
        end
      else
        return false
      end
    end
  end
end
