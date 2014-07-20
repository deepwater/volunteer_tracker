class ScheduledCheckInsService
  attr_reader :scope, :accessor

  def initialize(options = {})
    @accessor = options[:as]
  end

  def prepare_scheduled_data(scope = {})
    @scope = scope
    query = build_query
    query = query.group(
      "department_blocks.id, days.id, departments.id, users.id, charities.id, user_schedules.id"
    ).joins(
      "LEFT OUTER JOIN check_ins ON check_ins.user_schedule_id = user_schedules.id"
    ).having(
      "COUNT(check_ins.*) = 0"
    )
    query = scheduled_sort(query)
    query = search_results(query)
    query = query.includes(:charity, :user, department_block: [:day, :department])
    query = query.page(scope[:page]).per(scope[:per])
  end

  private

  def build_query
    query = UserSchedule
    department_block_ids = case accessor.role.to_sym
      when :department_manager then DepartmentBlock.where(department_id: accessor.department_manager.try(:department_id)).pluck(:id)
      when :department_assistant then DepartmentBlock.where(department_id: accessor.department_assistant.try(:department_id)).pluck(:id)
      when :volunteer_manager then [*accessor.volunteer_manager.try(:department_block_id)]
    end

    day = Day.where("year = ? AND month = ? AND mday = ?", scope[:year], scope[:month], scope[:day]).first
    if day
      day_department_block_ids = DepartmentBlock.where(day_id: day.id).pluck(:id)
      day_user_schedule_ids = UserSchedule.where(department_block_id: day_department_block_ids).pluck(:id)
    end

    if department_block_ids
      user_schedule_ids = UserSchedule.where(department_block_id: department_block_ids).pluck(:id)
      query = query.where(id: (user_schedule_ids & day_user_schedule_ids))
    else
      query = query.where(id: day_user_schedule_ids)
    end

    query
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