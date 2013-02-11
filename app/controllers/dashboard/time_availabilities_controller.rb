class Dashboard::TimeAvailabilitiesController < ApplicationController
  def show
  end

  def create
  	@user_id = current_user.id
  	@day = params[:data][:day]

  	UserAvailability.where(:user_id => @user_id, :day => @day).delete_all
  	
  	params[:data][:availableTimes].each do |availableTime|
  		UserAvailability.create(:day => @day, :user_id => @user_id, :time_block => availableTime)
  	end
  end
end
