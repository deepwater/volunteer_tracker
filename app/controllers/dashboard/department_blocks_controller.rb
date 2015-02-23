  class Dashboard::DepartmentBlocksController < DashboardController

  DEFAULT_PER_PAGE = 10

  def index
    @department_blocks = DepartmentBlock.all
    @department_block = DepartmentBlock.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @department_blocks }
    end
  end

  def show
    department_block = DepartmentBlock.find params[:id]
    raise ActionController::RoutingError.new('Not Found') unless can?(:manage, department_block) || current_user.has_role?(:department_assistant, department_block)
    service = DepartmentBlocksService.new
    scope = OpenStruct.new(
      id:               params[:id],
      page:             (params[:page] || 1).to_i,
      per_page:         (params[:per_page] || DEFAULT_PER_PAGE).to_s.to_i,
      charity:          params[:charity],
      role:             params[:role],
      order_charity:    params[:order_charity],
      order_role:       params[:order_role],
      order_name:       params[:order_name],
      order_email:      params[:order_email],
      order_username:   params[:order_username],
      q:                params[:q]
    )
    @show_action_data = service.prepare_data_for_show_action(current_user, scope)

    respond_to do |format|
      format.html
      format.json do
       render json: @show_action_data.department_block
      end
      format.js do
      end
    end
  end

  def new
    @department_block = DepartmentBlock.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @department_block }
    end
  end

  def edit
    @department_block = DepartmentBlock.find(params[:id])
  end

  def create
    @department_block = DepartmentBlock.new(params[:department_block])

    start_time = Time.parse(@department_block.start_time)
    @department_block.start_time = start_time.strftime("%H:%M")

    end_time = Time.parse(@department_block.end_time)
    @department_block.end_time = end_time.strftime("%H:%M")


    respond_to do |format|
      if @department_block.save
        format.html { redirect_to ("/dashboard/departments/" + @department_block.department.id.to_s + "#" + @department_block.day.safe_short_date), notice: 'Department block was successfully created.' }
        format.json { render json: @department_block, status: :created, location: @department_block }
      else
        format.html { render action: "new" }
        format.json { render json: @department_block.errors, status: :unprocessable_entity }
      end
    end
  end

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

  def copy
    @day = Day.find(params[:id])

    @day_to_copy_to = Day.find(params[:day_to_copy_to])

    @department = Department.find(params[:department_id])

    @department.department_blocks.where("day_id = ?", @day.id).all.each do |department_block|
      new_record = department_block.dup
      new_record.day_id = @day_to_copy_to.id
      new_record.save
    end

    redirect_to ("/dashboard/departments/" + @department.id.to_s + "#" + @day_to_copy_to.safe_short_date), notice: 'Department blocks were successfully copied.'

  end

  def destroy
    @department_block = DepartmentBlock.find(params[:id])
    @department_block.destroy

    respond_to do |format|
      format.html { redirect_to dashboard_department_url(@department_block.department) }
      format.json { head :no_content }
    end
  end

  def export

    day=DateTime.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    department=Department.find(params[:id].to_i)


    csv_string = CSV.generate do |csv|
      csv << ["day", "department_name", "department_block_name", "department_block_start", "department_block_end", "user_schedule_id", "user_fullname", "user_charity_name", "user_email", "user_secondary_email", "user_t-shirt_size", "user_cell_phone_number", "user_home_phone_number"]
      Day.where(
        month: params[:month].to_i, mday: params[:day].to_i, year: params[:year].to_i
      ).first.department_blocks.where(department_id: params[:id].to_i).all.each do |department_block|
          department_block.users.each_with_index do |user, index|
            line=[
              "#{params[:year].to_i}/#{params[:month].to_i}/#{params[:day].to_i}",
              department_block.department.name,
              department_block.name,
              department_block.start_time,
              department_block.end_time,
              department_block.user_schedules.where(user_id: user.id).first.id,
              user.full_name,
              department_block.users.where(id: user.id).first.try(:charities).try(:first).try(:name),
              user.email,
              user.secondary_email,
              user.tshirt_size,
              user.cell_phone,
              user.home_phone
            ]
            csv << line
          end
          if department_block.users.size<1
            line=[
              "#{params[:year].to_i}/#{params[:month].to_i}/#{params[:day].to_i}",
              department_block.department.name,
              department_block.name,
              department_block.start_time,
              department_block.end_time
            ]
            csv << line
          end

        end
    end
    send_data csv_string,
          :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=department_blocks_#{department.name.sub(/\s/,'_')}_#{params[:year].to_i}_#{params[:month].to_i}_#{params[:day].to_i}.csv"
  end
end
