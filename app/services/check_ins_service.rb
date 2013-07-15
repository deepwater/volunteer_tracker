class CheckInsService
  attr_reader :scope, :accessor

  def initialize(options = {})
    @accessor = options[:as]
  end

  def prepare_check_ins_data(type, scope)
    @scope = scope
    query = build_query
    query = send(:"filter_#{type}", query)
    query = sort_common(query)
    query = send(:"sort_#{type}", query)
    #query = sort_results(query, scope)
    query = search_results(query)
    query = query.includes(user_schedule: [{ user: :charities } , { department_block: :department }])
    paginate_results(query)
  end

  private

  def build_query
    query = CheckIn
    department_block_ids = case accessor.role.to_sym
      when :department_manager then DepartmentBlock.where(department_id: accessor.department_manager.try(:department_id)).pluck(:id)
      when :department_assistant then DepartmentBlock.where(department_id: accessor.department_assistant.try(:department_id)).pluck(:id)
      when :volunteer_manager then [*accessor.volunteer_manager.try(:department_block_id)]
    end
    
    if department_block_ids
      user_schedule_ids = UserSchedule.where(department_block_id: department_block_ids).pluck(:id)
      query = query.where(user_schedule_id: user_schedule_ids)
    end
    query
  end

  def sort_results(query)
    orderings = %w(ASC DESC)
    sortings = %w(department_id )

    if scope[:sort_by] && oprderings.includes?(scope[:order])
      query = ""
    end
  end

  def paginate_results(query)
    query.page(scope[:page]).per(scope[:per])
  end

  def search_results(query)
    return query unless scope[:q].present?
    query = query.where(
      "concat(lower(users.first_name), ' ', lower(users.last_name)) LIKE ? OR lower(users.email) LIKE ?",
      "%#{scope[:q].to_s.downcase}%",
      "%#{scope[:q].to_s.downcase}%"
    )
  end

  def filter_active(query)
    query.where(status: "1")
  end

  def filter_inactive(query)
    query.where(status: "2")
  end

  def valid_order?(direction)
    %w[asc desc].include?(direction)
  end

  def sort_common(query)
    if valid_order?(scope[:order_charity])
      query = query.order("charities.name #{scope[:order_charity]}")
    end
    if valid_order?(scope[:order_department])
      query = query.order("departments.id #{scope[:order_department]}")
    end
    if valid_order?(scope[:order_name])
      query = query.order("concat(lower(users.first_name), lower(users.last_name)) #{scope[:order_name]}")
    end
    if valid_order?(scope[:order_check_in])
      query = query.order("check_ins.created_at #{scope[:order_check_in]}")
    end
    query
  end

  def sort_active(query)
    query
  end

  def sort_inactive(query)   
    if valid_order?(scope[:order_check_out])
      query = query.order("check_ins.check_out_time #{scope[:order_check_out]}")
    end
    query
  end
end