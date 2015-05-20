class Admin::DepartmentManagersController < Admin::BaseController
  before_action :department_manager, only: [:destroy]

  def create
    @department_manager = DepartmentManager.new(department_manager_params)

    # Update user role
    user = @department_manager.user
    user.role = "department_manager"
    user.save
    department = @department_manager.department
    user.add_role :department_manager, department

    respond_to do |format|
      if @department_manager.save
        format.html { redirect_to admin_department_path(@department_manager.department), notice: 'Department Manager was successfully created.' }
        format.json { render json: @department_manager, status: :created, location: @department_manager }
      else
        format.html { render action: "new" }
        format.json { render json: @department_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @department_manager.user.remove_role(:department_manager)
    @department_manager.destroy

    respond_to do |format|
      format.html { redirect_to [:dashboard, @department_manager.department] }
      format.json { head :no_content }
    end
  end

  private
    def department_manager
      @department_manager = DepartmentManager.find(params[:id])
    end

    def department_manager_params
      params.require(:department_manager).permit!
    end
end