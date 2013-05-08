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
  		users = []

  		# Gets a list of users who have a time availability at the start of the block
      @list_of_availabilities = self.day.user_availabilities

      @list_of_availabilities.each do |user_availability|
        start_time = Time.parse(self.start_time)
        end_time = Time.parse(self.end_time)

        block_time_range = Time.parse(self.start_time).. Time.parse(self.end_time)

        availabilityRange = Time.parse(user_availability.start_time).. Time.parse(user_availability.end_time)

        start_check = UserAvailability.where("(TIMEDIFF(start_time, ?) * TIMEDIFF(?, end_time)) >= 0", user_availability.end_time, user_availability.start_time)

        logger.debug "BLAH #{start_check.all}"
      end
  		# @users = User.joins(:user_availabilities).where(user_availabilities: {time: self.start_time, day_id: self.day.id}).all

  		# Find length of time 
  		# start_time = Time.parse(self.start_time)
  		# end_time = Time.parse(self.end_time)
  		# duration = (end_time - start_time) / 60
  		# numberOfUserBlocks = duration / 15

    #   logger.debug "#{@users}"
  		# # Loop through the set of users
  		# @users.each do |user|
  		# 	# Check if user is eligible for each of the EventTimeslots
  		# 	is_eligible = false
  		# 	is_available = false

  		# 	availability_errors = 0

  		# 	num_availabilities = user.user_availabilities.where(time: [self.start_time...self.end_time]).length

  		# 	is_eligible = true if num_availabilities == numberOfUserBlocks
    #     logger.debug "num_availabilities: #{num_availabilities} numberOfUserBlocks: #{numberOfUserBlocks}"

  		# 	# If they passed the eligibility check
  		# 	if is_eligible

  		# 		availability_errors = 0;
  		# 		# Loop through user schedules

 			# 	availability_errors += 1 if user.department_blocks.where(start_time: [self.start_time...self.end_time]).length > 0
  		# 		availability_errors += 1 if user.department_blocks.where(end_time: [self.start_time...self.end_time]).length > 0
   	# 		end

  		# 	is_available = true if availability_errors == 0 && is_eligible == true
  			
  		# 	perfect_users << user if is_eligible && is_available
  		# end

  		users
  	end
end
