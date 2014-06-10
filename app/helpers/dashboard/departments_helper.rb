module Dashboard::DepartmentsHelper
  def get_estimated_hours(department_id)
    @department = Department.find(department_id)
    total = 0
    @department.department_blocks.each do |department_block|
      start_time = department_block.start_time.utc_date
      end_time = department_block.end_time.utc_date

      duration_in_minutes = (end_time.to_f - start_time) / 60 
      duration_in_hours = duration_in_minutes / 60

      if department_block.suggested_number_of_workers
        total += department_block.suggested_number_of_workers * duration_in_hours
      end
    end

    return total
  end


  def get_department_usage(estimated_hours, allocated_hours)

    if allocated_hours == 0
      return 100
    else
      return ( estimated_hours.to_f / allocated_hours.to_f ) * 100
    end

  end

  def get_department_usage_class(estimated_hours, allocated_hours)

    if estimated_hours.to_f > allocated_hours.to_f
      return "progress-bar-danger"
    else
      return ""
    end
  end
end
