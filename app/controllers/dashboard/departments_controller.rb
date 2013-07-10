class Dashboard::DepartmentsController < DashboardController

  # GET /departments/1
  # GET /departments/1.json
  def show
    @department         = Department.find(params[:id])
    @department_blocks  = DepartmentBlock.where(:department_id => @department.id)
    @department_block   = DepartmentBlock.new

    @days = Day.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @department }
    end
  end

  # GET /departments/1/edit
  def edit
    @department = Department.find(params[:id])
    @department_assistant = DepartmentAssistant.new

    @users = []

    @users << User.where(role: "volunteer")
    @users << User.where(role: "volunteer_manager")
    @department_assistants = User.where(role: "department_assistant")

    @department_assistants.select!{|user|
      user.department_assistant.nil? && !user.eql?(current_user)
    }

    if current_user.role? "department_manager"
      @users << @department_assistants
    end

    @users.flatten!

  end

  def schedule

    @department = Department.find(params[:id])
    @department_block = DepartmentBlock.new()
    @days = Day.all
    @day=Day.where("year = ? AND month = ? AND  mday = ?", params[:year],params[:month],params[:day]).first

  end
end
