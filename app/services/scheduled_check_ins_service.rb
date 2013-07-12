class ScheduledCheckInsService
  attr_reader :scope, :accessor

  def initialize(options = {})
    @accessor = options[:as]
  end

  def prepare_scheduled_data(scope = {})
    @scope = scope
    query = build_query(accessor.role)
    query = query.group(
      "days.year, days.month, days.mday, department_blocks.end_time, user_schedules.id"
    ).joins(
      "LEFT OUTER JOIN check_ins ON check_ins.user_schedule_id = user_schedules.id"
    ).having(
      "COUNT(check_ins.*) = 0"
    ).joins(
      "LEFT JOIN department_blocks ON department_blocks.id = user_schedules.department_block_id"
    ).joins(
      "LEFT JOIN days ON days.id = department_blocks.day_id"
    )
    query = scheduled_sort(query)
    query = query.includes(:user, department_block: [:day, :department])
    query = query.page(scope[:page]).per(scope[:per])
  end

  private

  def build_query(user_role)
    query = case user_role.to_sym
      when :volunteer_manager then query_for_volunteer_manager
      when :department_assistant then query_for_department_assistant
      when :department_manager then query_for_department_manager
      when :event_administrator then query_for_event_administrator
    end
  end

  def query_for_volunteer_manager
    UserSchedule.where(department_block_id: accessor.volunteer_manager.try(:department_block_id))
  end

  def query_for_department_assistant
    department_block_ids = DepartmentBlock.where(department_id: accessor.department_assistant.try(:department_id)).pluck(:id)
    UserSchedule.where(department_block_id: department_block_ids)
  end

  def query_for_department_manager
    department_block_ids = DepartmentBlock.where(department_id: accessor.department_manager.try(:department_id)).pluck(:id)
    UserSchedule.where(department_block_id: department_block_ids)
  end
  
  def query_for_event_administrator
    UserSchedule
  end

  def scheduled_sort(query)
    query.order(
      "CAST((days.year || '-' || days.month || '-' || days.mday || ' ' || department_blocks.end_time) AS timestamp) ASC"
    )
  end
end