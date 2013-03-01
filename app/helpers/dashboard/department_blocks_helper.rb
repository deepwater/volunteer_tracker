module Dashboard::DepartmentBlocksHelper
	def get_day_ordered
	    all_timeslots = EventTimeslot.all.group_by{ |slot| 
	      t = Time.at(slot.utc_date).in_time_zone
	      t.strftime("%A, %-d %B , %Y")
	    }

	    ordered_list = []

	    all_timeslots.collect do |date, time_slots|
	      list_of_time_slots = []
	      time_slots.each do |time_slot|
	        list_of_time_slots << 
	        {
	          :readable_time => Time.at(time_slot.utc_date).in_time_zone.strftime("%l.%M%P"),
	          :time_slot_id => time_slot.id
	        }
	      end

	      parsed_date = Time.parse(date)
	      short_date = parsed_date.strftime('%m/%d')
		  ordered_list << {
	        :date => date,
	        :short_date => short_date,
	        :safe_short_date => parsed_date.strftime('%m%d'),
	        :time_slots => list_of_time_slots
	      }

	    end
		
		return ordered_list
  	end
end
