class ChargesController < ApplicationController
  def new
    @plans = Plan.all.where(active: true)
  end

  def create
    plan = Plan.find(params[:plan_id])    

    if params[:auto_bill] == "true"
      customer = StripeService.create_and_subscribe_customer(params[:stripeToken], current_user, plan)
      current_user.update(plan_id: plan.id, membership_expiration: 1.year.from_now, stripe_customer_id: customer.id, auto_renew: true)
    else
      customer = StripeService.create_and_charge_customer(params[:stripeToken], current_user, plan)
      current_user.update(plan_id: plan.id, membership_expiration: 1.year.from_now, stripe_customer_id: customer.id, auto_renew: false)
    end
  
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path

  end

  def renew
    @plan = current_user.plan_id
  end

end
