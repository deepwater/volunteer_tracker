class DepartamentService
  attr_reader :scope, :accessor

  def initialize(options = {})
    @accessor = options[:as]
  end

  def prepare_single(select, id)
    query = build_query
    query = build_select(query, select)
    query = group_and_order(query)
    query.find(id)
  end

  def prepare_data(select, scope = {})
    @scope = scope
    query = build_query
    query = build_select(query, select)
    query = group_and_order(query)
    paginate(query)
  end

  def volunteer_hours_progress(department_ids)
    result = CheckIn
    .where("check_ins.status = '2'")
    .where("department_blocks.department_id IN (?)", [*department_ids])
    .joins("LEFT OUTER JOIN user_schedules ON user_schedules.id = check_ins.user_schedule_id")
    .joins("LEFT OUTER JOIN department_blocks ON department_blocks.id = user_schedules.department_block_id")
    .select("department_blocks.department_id, SUM(extract(epoch from (check_ins.check_out_time - check_ins.created_at))) as total_seconds")
    .group("department_blocks.department_id").inject({}){ |h, o| h.merge!({ o.department_id.to_i => o.total_seconds.to_i/3600 }) }
  end

  def users_for_promote(scope = {})
    @scope = scope
    users = User.where("users.id != ?", accessor.id).select("
      users.*, CONCAT(users.first_name, ' ', users.last_name) AS full_name
    ")
    if accessor.has_role? :department_manager
      users = users.joins("
        LEFT OUTER JOIN department_assistants ON department_assistants.user_id = users.id
      ").where("
        role IN ('volunteer', 'volunteer_manager') OR ( role = 'department_assistant' AND department_assistants.id IS NULL)
      ")
    else
      users = users.where(role: %w(volunteer volunteer_manager))
    end

    if valid_order? scope[:order_name]
      users = users.order("full_name #{scope[:order_name]}")
    elsif valid_order? scope[:order_role]
      users = users.order("users.role #{scope[:order_role]}")
    else
      users = users.order("full_name ASC")
    end

    users = search_results(users)
    paginate(users)
  end

  def assistans_for_assignment(scope = {})
    @scope = scope
    users = User.where(role: "department_assistant").where("users.id != ?", accessor.id)
    .joins("LEFT OUTER JOIN department_assistants ON department_assistants.user_id = users.id")
    .where("department_assistants.id IS NULL")

    users = search_results(users)
    paginate(users)
  end

  private

  def search_results(query)
    if scope[:q].present?
      query = query.where(
        "CONCAT(users.first_name, ' ', users.last_name) LIKE ? OR lower(users.email) LIKE ?",
        "%#{scope[:q].to_s.downcase}%",
        "%#{scope[:q].to_s.downcase}%"
      )
    end
    query
  end

  def valid_order?(order)
    %w(asc desc).include?(order.to_s)
  end

  def build_query
    Department.joins("LEFT OUTER JOIN department_blocks ON department_blocks.department_id = departments.id")
  end

  def group_and_order(query)
    query.group("departments.id").order("departments.name")
  end

  def build_select(query, select)
    select_query = %w(departments.id departments.name departments.budgeted_hours)
    if select.total_slots
      select_query << "SUM(department_blocks.suggested_number_of_workers) as total_slots"
    end

    if select.estimate_hours
      select_query << %Q{
        SUM(
          (extract(epoch from (cast(department_blocks.end_time as time) - interval '1 second'))
          - 
          extract(epoch from (cast(department_blocks.start_time as time))) + 1)/3600 * department_blocks.suggested_number_of_workers) as estimate_hours_total
      }
    end

    if select.scheduled_count
      select_query << "SUM((SELECT COUNT(DISTINCT id) FROM user_schedules WHERE department_block_id = department_blocks.id)) as scheduled_count"
    end

    query.select select_query.join(', ')
  end

  def paginate(query)
    if scope[:page] || scope[:per]
      query = query.page(scope[:page]).per(scope[:per])
    end
    query
  end
end