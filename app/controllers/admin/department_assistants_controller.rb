class Admin::DepartmentAssistantsController < DashboardController
  before_action :department_assistant, only: [:destroy, :restrict_blocks, :show_modal]
  respond_to :js, only: [:show_modal]

  def create
    @department_assistant = DepartmentAssistant.new(department_assistant_params)

    user = @department_assistant.user
    user.role = "department_assistant"
    user.save
    department = @department_assistant.department
    department.try(:department_blocks).each { |block| user.add_role :department_assistant, block }

    respond_to do |format|
      if @department_assistant.save
        format.html { redirect_to :back, flash: { success: 'Department Assistant was successfully created.' } }
        format.json { render json: @department_assistant, status: :created, location: @department_assistant }
      else
        format.html { render action: "new" }
        format.json { render json: @department_assistant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @department_assistant.user.remove_role(:department_assistant)
    @department_assistant.destroy

    respond_to do |format|
      format.html { redirect_to [:admin, @department_assistant.department] }
      format.json { head :no_content }
    end
  end

  def restrict_blocks
    user = @department_assistant.user
    if params[:department_blocks_ids].present?
      user.remove_role(:department_assistant)
      params[:department_blocks_ids].each do |id|
        block = DepartmentBlock.find(id) and user.add_role :department_assistant, block
      end
    end
    redirect_to :back
  end

  def show_modal
  end  

  private
    def department_assistant
      @department_assistant = DepartmentAssistant.find(params[:id])
    end

    def department_assistant_params
      params.require(:department_assistant).permit!
    end

end
