class CheckInsService
  attr_reader :scope, :accessor

  def initialize(options = {})
    @accessor = options[:as]
  end

  def prepare_check_ins_data(type, scope)
    query = build_query
    query = send(:"filter_#{type}", query)
    query = query.includes(user_schedule: [:user, :department_block])
    paginate_results(query, scope)
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

  def paginate_results(query, scope)
    query.page(scope[:page]).per(scope[:per])
  end

  def filter_active(query)
    query.where(status: "1")
  end

  def filter_inactive(query)
    query.where(status: "2")
  end
end