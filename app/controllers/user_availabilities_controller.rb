class UserAvailabilitiesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, only: [:index]
  respond_to :js, except: [:index]

  def index
    @user = User.find(params[:user_id]) || current_user
    @days = Day.all
  end

  def create
    @user = User.find(params[:user_id]) || current_user
    @availability = @user.user_availabilities.create(start_time: "00:00", end_time: "23:59", day_id: params[:user_availability][:day_id])
    @day = @availability.day
  end

  def destroy
    @user = User.find(params[:user_id]) || current_user
    @availability = UserAvailability.find(params[:id])
    @day = @availability.day
    @availability.destroy
  end
end
