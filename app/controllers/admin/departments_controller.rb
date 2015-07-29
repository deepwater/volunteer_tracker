class Admin::DepartmentsController < Admin::BaseController
  before_action :department, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: DepartmentDatatable.new(view_context) }
    end
  end

  def show
    @department_managers = User.includes(:department_manager).where(role: "department_manager")
    @department_managers.select!{|user| user.department_manager.nil? }


    @department_assistants = User.includes(:department_assistant).where(role: "department_assistant")
    @department_assistants.select!{|user| user.department_assistant.nil? }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @department }
    end
  end

  def new
    @department = Department.new
  end

  def edit
    @department_manager = DepartmentManager.new
  end

  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to [:admin, @department], notice: 'Department was successfully created.' }
        format.json { render json: @department, status: :created, location: [:admin, @department] }
      else
        format.html { render action: "new" }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @department.update_attributes(department_params)
        format.html { redirect_to [:admin, @department], notice: 'Department was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @department.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to admin_root_url(anchor: 'departments') }
      format.json { head :no_content }
    end
  end

  private
    def department
      @department = Department.find(params[:id])
    end

    def department_params
      params.require(:department).permit!
    end

end
