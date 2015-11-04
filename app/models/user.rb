class User < ActiveRecord::Base
	authenticates_with_sorcery!

	validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
	validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
	validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

	validates :email, uniqueness: true	

  belongs_to :plan

  def update_sub_info(options = {})
    expiration = options.fetch(:expiration, false)
    auto_bill = options.fetch(:auto_bill, false)
    plan = options.fetch(:plan, false)
    customer_id = options.fetch(:customer_id, false)
    if expiration
      self.membership_expiration = expiration
    end
    if auto_bill
      self.auto_renew = auto_bill
    end
    if plan
      self.plan_id = plan
    end    
    if customer_id
      self.stripe_customer_id = customer_id
    end    
    self.save
  end
end
