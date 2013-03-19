module Dashboard::DepartmentsHelper
	def get_estimated_hours(id)
		@department = Department.find(id)
		total = 0
		@department.department_blocks.each do |department_block|
			start_time = department_block.start_time.utc_date
			end_time = department_block.end_time.utc_date

			duration_in_minutes = (end_time.to_f - start_time) / 60 
			duration_in_hours = duration_in_minutes / 60

			total += department_block.suggested_number_of_workers * duration_in_hours
		end

		return total
	end
end
