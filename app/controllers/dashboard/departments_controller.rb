class Dashboard::DepartmentsController < DashboardController
  DEFAULT_PER_PAGE = 10
  before_filter :prepare_scope, only: [:for_promote, :assistants, :edit]
  before_filter :load_department, only: [:assistants, :edit]

  def show
    service = DepartamentService.new
    select = OpenStruct.new(
      total_slots: true,
      estimate_hours: true,
      scheduled_count: true
    )

    
    @department         = service.prepare_single(select, params[:id])
    @department_block   = DepartmentBlock.new
    @volunteer_hours = service.volunteer_hours_progress(@department.id)

    @days = Day.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @department }
    end
  end

  def edit
    @department_assistant = DepartmentAssistant.new
    @users = service.users_for_promote(@scope)
    @department_assistants = service.assistans_for_assignment(@scope)
  end

  def for_promote
    @users = service.users_for_promote(@scope)
  end

  def assistants
    @assistants = service.assistans_for_assignment(@scope)
  end

  def schedule
    @department = Department.find(params[:id])
    @department_block = DepartmentBlock.new()
    @days = Day.all
    @day=Day.where("year = ? AND month = ? AND  mday = ?", params[:year],params[:month],params[:day]).first
  end

  private

  def prepare_scope
    @scope = {
      per: (params[:per] || DEFAULT_PER_PAGE).to_i,
      page: (params[:page] || 1).to_i,
      order_name: params[:order_name],
      order_role: params[:order_role],
      q: params[:q]
    }
  end

  def service
    @service ||= DepartamentService.new(as: current_user)
  end

  def load_department
    @department = Department.find(params[:id])
  end
end
