class User < ActiveRecord::Base
	authenticates_with_sorcery!

	validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
	validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
	validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }
  validates :first_name, presence: true
  validates :last_name, presence: true

	validates :email, uniqueness: true	

  belongs_to :plan

  def self.scan_for_expirations
    all.each do |u|
      if u.membership_expiration < 2.weeks.from_now && u.auto_renew
        UserMailer.two_week_reminder_renewing(u).deliver_now
      elsif u.membership_expiration < 2.weeks.from_now && !u.auto_renew
        UserMailer.two_week_reminder_non_renewing(u).deliver_now
      elsif u.membership_expiration < Time.now && u.auto_renew
        UserMailer.expiration_notice(u).deliver_now
      end
    end
  end

  def self.email_q
    u = User.find_by_email("qdamji@gmail.com")
    pwd = SecureRandom.urlsafe_base64(5)
    UserMailer.created_account(u,pwd)
  end
end
