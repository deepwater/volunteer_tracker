class DepartamentService
  attr_reader :scope

  def prepare_data(select, scope = {})
    @scope = scope
    query = build_query(query)
    query = build_select(query, select)
    query = group_and_order(query)
    query = paginate(query)
  end

  private

  def build_query(query)
    Department.joins(:department_blocks)
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
      select_query << "SUM(extract(epoch from (cast(department_blocks.end_time as time) - cast(department_blocks.start_time as time)))/3600 * department_blocks.suggested_number_of_workers) as estimate_hours_total"
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