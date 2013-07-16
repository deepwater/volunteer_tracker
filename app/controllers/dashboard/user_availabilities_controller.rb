class Dashboard::UserAvailabilitiesController < ApplicationController
  before_filter :authenticate_user!  
  respond_to :html, :json

  def index
    @user_availability = UserAvailability.new

    @user_availabilities = UserAvailability.where(user_id: current_user.id)

    @setup_days = Day.where(day_type: 0)
    @festival_days = Day.where(day_type: 1)
    @tear_down_days = Day.where(day_type: 2)
  end

  def create
    @user_availability = UserAvailability.new(params[:user_availability])

    start_time = Time.parse(@user_availability.start_time)
    @user_availability.start_time = start_time.strftime("%H:%M")

    end_time = Time.parse(@user_availability.end_time)
    @user_availability.end_time = end_time.strftime("%H:%M")

    respond_to do |format|
      if @user_availability.save
        format.json { render json: {:template => render_to_string("dashboard/user_availabilities/show.json")}}
      else
        format.json { render json: @user_availability.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_availability = UserAvailability.find(params[:id])
    @user_availability.destroy

    render :nothing => true
  end
end
