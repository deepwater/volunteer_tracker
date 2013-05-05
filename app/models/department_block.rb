class DepartmentBlock < ActiveRecord::Base
	belongs_to :department
	belongs_to :day
	
	has_many :user_schedules
	has_many :users, :through => :user_schedules

	has_many :volunteer_managers

  def readable_start_time 
    t = Time.parse("#{self.start_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")

    return t.strftime("%l.%M%P %A %-d %B")
  end

  def readable_end_time 
    t = Time.parse("#{self.start_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")

    return t.strftime("%l.%M%P %A %-d %B")
  end

	def get_perfect_fit_users
  		# Stores eligible and available users
  		perfect_users = []

  		# Gets a list of users who have a time availability at the start of the block
  		# @users = User.joins(:user_availabilities).where(user_availabilities: {time: self.start_time, day_id: self.day.id}).all

  		# Find length of time 
  		start_time = Time.parse(self.start_time)
  		end_time = Time.parse(self.end_time)
  		duration = (end_time - start_time) / 60
  		numberOfUserBlocks = duration / 15

      logger.debug "#{@users}"
  		# Loop through the set of users
  		@users.each do |user|
  			# Check if user is eligible for each of the EventTimeslots
  			is_eligible = false
  			is_available = false

  			availability_errors = 0

  			num_availabilities = user.user_availabilities.where(time: [self.start_time...self.end_time]).length

  			is_eligible = true if num_availabilities == numberOfUserBlocks
        logger.debug "num_availabilities: #{num_availabilities} numberOfUserBlocks: #{numberOfUserBlocks}"

  			# If they passed the eligibility check
  			if is_eligible

  				availability_errors = 0;
  				# Loop through user schedules

 				availability_errors += 1 if user.department_blocks.where(start_time: [self.start_time...self.end_time]).length > 0
  				availability_errors += 1 if user.department_blocks.where(end_time: [self.start_time...self.end_time]).length > 0
   			end

  			is_available = true if availability_errors == 0 && is_eligible == true
  			
  			perfect_users << user if is_eligible && is_available
  		end

  		perfect_users
  	end

  	def get_semi_fit_user
  		# Stores eligible and available users
  		semi_perfect_users = []

  		# Gets a list of users who have a time availability at the start of the block
  		@users = User.joins(:user_availabilities).where(user_availabilities: {time: self.start_time, day_id: self.day.id}).all

  		# Find length of time 
  		start_time = Time.parse(self.start_time)
  		end_time = Time.parse(self.end_time)
  		duration = (end_time - start_time) / 60
  		numberOfUserBlocks = duration / 15

  		# Loop through the set of users
  		@users.each do |user|
  			# Check if user is eligible for each of the EventTimeslots
  			is_eligible = false
  			is_available = false

  			num_availabilities = user.user_availabilities.where(time: [self.start_time...self.end_time]).length

  			is_eligible = true if num_availabilities.length != numberOfUserBlocks.length && num_availabilities.length > 0

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
