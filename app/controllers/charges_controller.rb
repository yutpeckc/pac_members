class ChargesController < ApplicationController
  def new
    @plans = Plan.all.where(active: true)
  end

  def create
  end
end
