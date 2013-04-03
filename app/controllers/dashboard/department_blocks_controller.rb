class Dashboard::DepartmentBlocksController < DashboardController
  # GET /department_blocks
  # GET /department_blocks.json
  def index
    @department_blocks = DepartmentBlock.all
    @department_block = DepartmentBlock.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @department_blocks }
    end
  end

  # GET /department_blocks/1
  # GET /department_blocks/1.json
  def show
    @department_block = DepartmentBlock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @department_block }
    end
  end

  # GET /department_blocks/new
  # GET /department_blocks/new.json
  def new
    @department_block = DepartmentBlock.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @department_block }
    end
  end

  # GET /department_blocks/1/edit
  def edit
    @department_block = DepartmentBlock.find(params[:id])
  end

  # POST /department_blocks
  # POST /department_blocks.json
  def create
    @department_block = DepartmentBlock.new(params[:department_block])

    respond_to do |format|
      if @department_block.save
        format.html { redirect_to ("/dashboard/departments/" + @department_block.department.id.to_s + "#" + params[:day_hash]), notice: 'Department block was successfully created.' }
        format.json { render json: @department_block, status: :created, location: @department_block }
      else
        format.html { render action: "new" }
        format.json { render json: @department_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /department_blocks/1
  # PUT /department_blocks/1.json
  def update
    @department_block = DepartmentBlock.find(params[:id])

    respond_to do |format|
      if @department_block.update_attributes(params[:department_block])
        format.html { redirect_to dashboard_department_block_path(@department_block), notice: 'Department block was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @department_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /department_blocks/1
  # DELETE /department_blocks/1.json
  def destroy
    @department_block = DepartmentBlock.find(params[:id])
    @department_block.destroy

    respond_to do |format|
      # format.html { redirect_to dashboard_department_url(@department_block.department) }
      format.html { redirect_to dashboard_department_url(@department_block.department) }
      format.json { head :no_content }
    end
  end
end