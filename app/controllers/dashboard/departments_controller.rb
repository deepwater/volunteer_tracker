class Dashboard::DepartmentsController < DashboardController

  # GET /departments/1
  # GET /departments/1.json
  def show
    @department = Department.find(params[:id])
    @department_blocks = DepartmentBlock.where(:department_id => @department.id)
    @department_block = DepartmentBlock.new

    @days = Day.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @department }
    end
  end

  # GET /departments/1/edit
  def edit
    @department_assistant = DepartmentAssistant.new

    @department_assistants = User.where(role: "department_assistant")
    @department_assistants.select!{|user|
      user.department_assistant.nil? && !user.eql?(current_user)
    }
    
    @department = Department.find(params[:id])
  end
end