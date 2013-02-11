class Dashboard::TimeAvailabilitiesController < ApplicationController
  
  respond_to :html, :json

  def show 
    @time_slots = EventTimeslot.all.group_by{ |slot| 
      t = Time.at(slot.utc_date).in_time_zone
      # t.strftime("%m/%d")
      t.strftime("%A, %-d %B , %Y")
    }
    respond_to do |format|
      format.json{render :json => timeslots_as_json(@time_slots)}
    end
  end

  def timeslots_as_json(event_time_slots)
    event_time_slots.collect do |date, time_slots|
      list_of_time_slots = []
      time_slots.each do |time_slot|
        list_of_time_slots << Time.at(time_slot.utc_date).in_time_zone.strftime("%H:%M%P")
      end

      {
        :date => date,
        :time_slots => list_of_time_slots
      }
    end.to_json
    # logger.debug "#{Time.zone.now}"
  end

  def index
    @time_slots = EventTimeslot.all.group_by{ |slot| 
      t = Time.at(slot.utc_date).in_time_zone
      # t.strftime("%m/%d")
      t.strftime("%A, %-d %B , %Y")
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
