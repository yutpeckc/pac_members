class ChargesController < ApplicationController
  def new
    if current_user.current_user.membership_expiration.present? && current_user.plan_id.present?
      @plans = []
      @plans << current_user.plan_id
    else
      @plans = Plan.all.where(active: true)
    end
    @size = 4
    case @plans.count
    when 1
      @offset = 4
    when 2
      @offset = 2
    else
      @offset = 0
    end
  end

  def create
    plan = Plan.find(params[:plan_id])    

    if params[:auto_bill] == "true"
      customer = StripeService.create_and_subscribe_customer(params[:stripeToken], current_user, plan)
      current_user.update(plan_id: plan.id, membership_expiration: 1.year.from_now, stripe_customer_id: customer.id, auto_renew: true, dont_remind: false)
    else
      customer = StripeService.create_and_charge_customer(params[:stripeToken], current_user, plan)
      current_user.update(plan_id: plan.id, membership_expiration: 1.year.from_now, stripe_customer_id: customer.id, auto_renew: false, dont_remind: false)
    end

    m = Mailchimp.new
    m.change_membership(current_user,"member")
  
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path

  end

  def renew
    @plan = current_user.plan_id
  end

end
