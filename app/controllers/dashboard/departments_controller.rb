class Dashboard::DepartmentsController < DashboardController

  def index
    @departments = Department.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @departments }
    end
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
    @department = Department.find(params[:id])
    @department_blocks = DepartmentBlock.where(:department_id => @department.id)
    @department_block = DepartmentBlock.new


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @department }
    end
  end

  # GET /departments/1/edit
  def edit
    @lt_department_manager = LtDepartmentManager.new
    @department = Department.find(params[:id])
  end
end