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

  def overlaps?(other)
    dep_block_start = Time.parse("#{self.start_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")
    dep_block_end = Time.parse("#{self.end_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")
    
    other_dep_block_start = Time.parse("#{other.start_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")
    other_dep_block_end = Time.parse("#{other.end_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")

    (dep_block_start - other_dep_block_end) * (other_dep_block_start - dep_block_end) >= 0
  end

  def overlap(other)
    dep_block_start = Time.parse("#{self.start_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")
    dep_block_end = Time.parse("#{self.end_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")
    
    other_dep_block_start = Time.parse("#{other.start_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")
    other_dep_block_end = Time.parse("#{other.end_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")

    (dep_block_start - other_dep_block_end) * (other_dep_block_start - dep_block_end)
  end

  def duration
    start_time = Time.parse(self.start_time)
    end_time = Time.parse(self.end_time)
    
    end_time - start_time
  end

	def get_user_availabilities
  		# Stores eligible and available users
  		user_availabilities = []

  		# Gets a list of users who have a time availability at the start of the block
      @list_of_availabilities = self.day.user_availabilities

      # Get duration of department block
      start_time = Time.parse(self.start_time)
      end_time = Time.parse(self.end_time)
      duration = self.duration

      availabilities = []

      @list_of_availabilities.each do |user_availability|

        if self.overlaps?(user_availability)
          availabilities << user_availability
        end

      end

      availabilities.each do |user_availability|
        user = user_availability.user

        if !user.role?(:department_manager) && !user.role?(:event_administrator)

          eligibility_errors = 0

          user.user_schedules.each do |user_schedule|
            user_schedule_block = user_schedule.department_block
            duration = user_schedule_block.duration

            # overlap = user_schedule_block.overlap(user_availability)
            # overlap_percentage = (overlap / duration) * 100

            # logger.debug "OVERLAP: #{overlap}"
            # logger.debug "DURATION: #{duration}"
            # logger.debug "OVERLAP_PERCENTAGE: #{overlap_percentage}"

            if user_schedule_block.overlaps?(user_availability)
              eligibility_errors += 1
            end

            # logger.debug "SELF.ID: #{self.id}"
            # logger.debug "USER_SCHEDULE_BLOCK.ID: #{user_schedule_block.id}"

            if self.id == user_schedule_block.id
              # logger.debug "TEST SUCCEEDS"
              eligibility_errors += 1
            end
          end

          # logger.debug "ELIGIBLITY_ERRORS: #{eligibility_errors}"
          user_availabilities << user_availability if eligibility_errors == 0 
        end
      end

      user_availabilities
 
  	end
end
