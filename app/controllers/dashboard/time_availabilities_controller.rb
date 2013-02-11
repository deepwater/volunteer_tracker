class Dashboard::TimeAvailabilitiesController < ApplicationController
  
  respond_to :html, :json

  def show
    @time_slots = EventTimeslot.all.group_by{ |slot| 
      t = Time.at(slot.utc_date).in_time_zone
      t.strftime("%m/%d")
    }
  	respond_with(@time_slots)

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
