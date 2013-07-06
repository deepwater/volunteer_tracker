class Department < ActiveRecord::Base
	has_many :department_managers
	has_many :department_assistants
	
	has_many :department_blocks

	def estimated_hours
		total = 0

		self.department_blocks.each do |department_block|
			start_time = Time.parse(department_block.start_time)
			end_time = Time.parse(department_block.end_time)

			duration_in_minutes = (end_time - start_time) / 60 
			duration_in_hours = duration_in_minutes / 60

			if department_block.suggested_number_of_workers
				total += department_block.suggested_number_of_workers * duration_in_hours
			end
		end

		return total
	end

	def fully_scheduled_blocks
		count = 0

		self.department_blocks.each do |department_block|
			if department_block.user_schedules.count == department_block.suggested_number_of_workers
				count= count+1
			end 
		end

		logger.debug "COUNT #{count}"
		count
	end
end
