class UserAvailabilitiesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, only: [:index]
  respond_to :js, except: [:index]

  def index
    
  end

  def create
    @subaccount = User.find(params[:subaccount_id])
    @availability = @subaccount.user_availabilities.create(start_time: "00:00", end_time: "23:59", day_id: params[:user_availability][:day_id])
    @day = @availability.day
  end

  def destroy
    @subaccount = User.find(params[:subaccount_id])
    @availability = UserAvailability.find(params[:id])
    @day = @availability.day
    @availability.destroy
  end
end
