class ChargesController < ApplicationController
  def new
    @plans = Plan.all.where(active: true)
  end

  def create
    # dump
    # {"utf8"=>"✓", "authenticity_token"=>"sz63bqOpv2jwaDgSOgwS0EWEx9wPlTbuTF1hoOXr2k80MOHuw6hF9fgOEWm3qZb9DTQaShQMonJNTfd3dtVj2g==", "auto_bill"=>"true", "plan_id"=>"1", "plan_stripe_id"=>"pac_member_2015", "stripeToken"=>"tok_173J9zGacknxsRjuby4D3ter", "stripeTokenType"=>"card", "stripeEmail"=>"qdamji@gmail.com", "controller"=>"charges", "action"=>"create"}

    plan = Plan.find(params[:plan_id])    

    if params[:auto_bill] == "true"
      customer = Stripe::Customer.create(
        :email => current_user.email,
        :card => params[:stripeToken],
        :plan => plan.plan_stripe_id
      )      
      current_user.update_sub_info({plan: plan.id, expiration: 1.year.from_now, customer_id: customer.id, auto_bill: true})
    else
      customer = Stripe::Customer.create(
        :email => current_user.email,
        :card => params[:stripeToken]
      )      
      
      charge = Stripe::Charge.create(
        :customer => customer.id,
        :amount => plan.price,
        :description => plan.name,
        :currency => 'cad'
      )
      current_user.update_sub_info({plan: plan.id, expiration: 1.year.from_now, customer_id: customer.id, auto_bill: false})      
    end
  
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path

  end

end
