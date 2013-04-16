class Dashboard::UserAvailabilitiesController < ApplicationController
  
  respond_to :html, :json

  def index
    @first_day = Day.first
  end

  def create
  	@user_id = current_user.id

  	UserAvailability.where(user_id: @user_id, day_id: params[:data][:day_id]).delete_all

  	params[:data][:availableTimes].each do |availableTime|
      time = Time.parse(availableTime)
      formatted_time = time.strftime("%H:%M")

  		UserAvailability.create(user_id: @user_id, time: formatted_time, day_id: params[:data][:day_id])
  	end
  end
end
