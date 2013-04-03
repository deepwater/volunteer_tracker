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

  	def get_perfect_fit_users(department_block)
  		# Stores eligible and available users
  		perfect_users = []

  		# Gets a list of users who have a time availability at the start of the block
  		@users = department_block.start_time.users.where("role != ?","department_manager") #Added in this line to avoid department_managers

  		# Create a array of the EventTimeslots between DepartmentBlock start_time and end_time
  		event_timeslots = EventTimeslot.where(id: [department_block.start_time.id..department_block.end_time.id])

  		# Loop through the set of users
  		@users.each do |user|
  			# Check if user is eligible for each of the EventTimeslots
  			is_eligible = false
  			is_available = false

  			availability_errors = 0

  			is_eligible = true if user.event_timeslots.each_cons(event_timeslots.size).include? event_timeslots

  			# If they passed the eligibility check
  			if is_eligible

  				availability_errors = 0;
  				# Loop through user schedules

  				user.department_blocks.each do |dep_block|
  					#Get an array of EventTimeslots for each Department Block and check for clashes
			  		other_department_block_event_timeslots = EventTimeslot.where(id: [dep_block.start_time.id..dep_block.end_time.id])
			  		availability_errors += 1 if other_department_block_event_timeslots & event_timeslots
  				end
  			end

  			is_available = true if availability_errors == 0 && is_eligible == true
  			
  			perfect_users << user if is_eligible && is_available
  		end

  		perfect_users
  	end

  	def get_semi_fit_users(department_block)
  		# Stores eligible and available users
  		semi_perfect_users = []

  		# Gets a list of users who have a time availability at the start of the block
  		@users = User.includes(:event_timeslots).where("event_timeslots.id" => [department_block.start_time.id..department_block.end_time.id]).all

  		# Create a array of the EventTimeslots between DepartmentBlock start_time and end_time
  		event_timeslots = EventTimeslot.where(id: [department_block.start_time.id..department_block.end_time.id])

  		# Loop through the set of users
  		@users.each do |user|
  			# Check if user is eligible for each of the EventTimeslots
  			is_eligible = false
  			is_available = false

  			intersections = user.event_timeslots & event_timeslots

  			is_eligible = true if intersections.length != event_timeslots.length && intersections.length > 0

  			# If they passed the eligibility check
  			if is_eligible

  				availability_errors = 0;
  				# Loop through user schedules

  				user.department_blocks.each do |dep_block|
  					#Get an array of EventTimeslots for each Department Block and check for clashes
			  		other_department_block_event_timeslots = EventTimeslot.where(id: [dep_block.start_time.id..dep_block.end_time.id])
			  		availability_errors += 1 if other_department_block_event_timeslots & event_timeslots
  				end
  			end

  			is_available = true if availability_errors == 0 && is_eligible == true
  			
  			availability_percentage = (intersections.length.to_f / event_timeslots.length.to_f) * 100
  			semi_perfect_users << [user,intersections, availability_percentage.to_i] if is_eligible && is_available

  		end

  		semi_perfect_users.sort_by{|e| e[2]}.reverse
  	end
end
