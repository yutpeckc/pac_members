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
        u.send_two_week_warning(true)
      elsif u.membership_expiration < 2.weeks.from_now && !u.auto_renew
        u.send_two_week_warning(false)
      elsif u.membership_expiration < Time.now && u.auto_renew
        u.send_expired_notice
      end
    end
  end

  def send_two_week_warning(renewing?)

  end

  def send_expired_notice

  end
end
