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

  def self.sync_plans
    plans = Stripe::Plan.all.data
    plans.each do |p|
      current = Plan.find_by_plan_stripe_id(p.id)
      if current.nil?
        Plan.create(plan_stripe_id: p.id, price: p.amount, name: p.name, active: false)
      else
        current.price = p.amount
        current.name = p.name
        current.save
      end
    end
  end

end