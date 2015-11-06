ActiveAdmin.register Plan do
  permit_params :active

  index do
    selectable_column
    id_column
    column :price
    column :name
    column :plan_stripe_id
    column :active
    column "Activate/Deactivate" do |plan| 
      if plan.active
        text = "Deactivate"
      else
        text = "Activate"
      end
        link_to text, activate_deactivate_admin_plan_path(plan.id)
    end
  end

  collection_action :sync do
    StripeService.sync_plans
    redirect_to admin_plans_path, notice: "Plans synced with Stripe!"
  end

  member_action :activate_deactivate do
    plan = Plan.find(params[:id])
    if plan.active
      text = "deactivated"
    else
      text = "activated"
    end
    plan.active = !plan.active
    plan.save
    redirect_to admin_plans_path, notice: "Plan #{text}!"
  end

  action_item :sync_with_stripe, only: :index do
    link_to 'Sync With Stripe', sync_admin_plans_path
  end

  form do |f|
    f.inputs "User Details" do
      f.input :active
    end
    f.actions
  end  

end
