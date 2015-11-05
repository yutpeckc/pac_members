class StripeService

  def self.create_and_subscribe_customer(token,user,plan)
    Stripe::Customer.create(
      :email => user.email,
      :card => token,
      :plan => plan.plan_stripe_id
    )    
  end

  def self.create_and_charge_customer(token,user,plan)
      customer = Stripe::Customer.create(
        :email => user.email,
        :card => token
      )      
      
      charge = Stripe::Charge.create(
        :customer => customer.id,
        :amount => plan.price,
        :description => plan.name,
        :currency => 'cad'
      )

      customer
  end

end