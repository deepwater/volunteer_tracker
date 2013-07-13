class ScheduledCheckInsService
  attr_reader :scope, :accessor

  def initialize(options = {})
    @accessor = options[:as]
  end

  def prepare_scheduled_data(scope = {})
    @scope = scope
    query = build_query(accessor.role)
    query = query.group(
      "department_blocks.id, days.id, departments.id, users.id, charities.id, user_schedules.id"
    ).joins(
      "LEFT OUTER JOIN check_ins ON check_ins.user_schedule_id = user_schedules.id"
    ).having(
      "COUNT(check_ins.*) = 0"
    )
    query = scheduled_sort(query)
    query = search_results(query)
    query = query.includes(user: :charities, department_block: [:day, :department])
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

  def search_results(query)
    return query unless scope[:q].present?
    query = query.where(
      "concat(lower(users.first_name), ' ', lower(users.last_name)) LIKE ? OR lower(users.email) LIKE ?",
      "%#{scope[:q].to_s.downcase}%",
      "%#{scope[:q].to_s.downcase}%"
    )
  end

  def scheduled_sort(query)
    if valid_order?(scope[:order_charity])
      query = query.order("charities.name #{scope[:order_charity]}")
    end
    if valid_order?(scope[:order_department])
      query = query.order("departments.id #{scope[:order_department]}")
    end
    if valid_order?(scope[:order_name])
      query = query.order("concat(lower(users.first_name), lower(users.last_name)) #{scope[:order_name]}")
    end
    query.order(
      "CAST((days.year || '-' || days.month || '-' || days.mday || ' ' || department_blocks.end_time) AS timestamp) ASC"
    )
  end

  def valid_order?(direction)
    %w[asc desc].include?(direction)
  end
end