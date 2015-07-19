class Admin::DepartmentsController < Admin::BaseController

  def index
    respond_to do |format|
      format.html
      format.json { render json: DepartmentDatatable.new(view_context) }
    end
  end

  def show
    @department = Department.find(params[:id])

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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @department }
    end
  end

  def edit
    @department = Department.find(params[:id])
    @department_manager = DepartmentManager.new
  end

  def create
    @department = Department.new(params[:department])

    respond_to do |format|
      if @department.save
        format.html { redirect_to admin_department_path(@department), notice: 'Department was successfully created.' }
        format.json { render json: @department, status: :created, location: @department }
      else
        format.html { render action: "new" }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @department = Department.find(params[:id])

    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html { redirect_to admin_department_path(@department), notice: 'Department was successfully updated.' }
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
    @department = Department.find(params[:id])
    @department.destroy

    respond_to do |format|
      format.html { redirect_to admin_root_url(anchor: 'departments') }
      format.json { head :no_content }
    end
  end

end
