class Dashboard::CheckInsController < DashboardController
  DEFAULT_PER_PAGE = 10
  before_filter :set_scope, only: [:scheduled_tab, :active_tab, :inactive_tab, :manage]
  before_filter :volunteer_manager?, only: [:scheduled, :active, :inactive]
  before_filter :fastpass_acessible, only: [:fastpass, :fastpass_out]

  def show
    @check_in = CheckIn.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @check_in }
    end
  end

  # Same as scheduled tab
  def manage
    @day = Day.where("year = ? AND month = ? AND mday = ?", params[:year],params[:month],params[:day]).first
    @service = ScheduledCheckInsService.new(as: current_user)
    @results = @service.prepare_scheduled_data(@scope)
  end

  def scheduled_tab
    @day = Day.where("year = ? AND month = ? AND mday = ?", params[:year],params[:month],params[:day]).first
    @service = ScheduledCheckInsService.new(as: current_user)
    @results = @service.prepare_scheduled_data(@scope)
    respond_to do |format|
      format.js
    end
  end

  def active_tab
    @day = Day.where("year = ? AND month = ? AND mday = ?", params[:year],params[:month],params[:day]).first
    @results = check_ins_service.prepare_check_ins_data(:active, @scope)
    respond_to do |format|
      format.js
    end
  end

  def inactive_tab
    @day = Day.where("year = ? AND month = ? AND mday = ?", params[:year],params[:month],params[:day]).first
    @results = check_ins_service.prepare_check_ins_data(:inactive, @scope)
    respond_to do |format|
      format.js
      format.csv do
        @scope.delete(:per)
        data = check_ins_service.prepare_check_ins_data(:inactive, @scope)
        send_data(
          csv_service.export("check_ins_inactive", data),
          type: 'text/csv; charset=utf-8; header=present', filename: csv_service.filename
        )
      end
    end
  end

  def new
    @check_in = CheckIn.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @check_in }
    end
  end

  def edit
    @check_in = CheckIn.find(params[:id])
  end

  def fastpass
    @check_in = CheckIn.new
  end

  def fastpass_out
  end

  def check_out
    service = CheckInsService.new(as: current_user)
    @check_in = service.check_out(params[:check_in]["user_schedule_id"])

    if @check_in.is_a? String
      render json: { errors: [*@check_in] }
    else
      render json: { user_data: FastPassPresenter.new.for_json(@check_in) }
    end
  end

  def create
    service = CheckInsService.new(as: current_user, fastpass: params[:fastpass].present?)
    @check_in = service.create(params[:check_in])

    respond_to do |format|
      if @check_in.persisted?
        format.html { redirect_to :back, notice: 'Check in was successfully created.' }
        format.json { render json: { user_data: FastPassPresenter.new.for_json(@check_in) } }
      else
        format.html { redirect_to :back, alert: @check_in.errors.values.join(', ') }
        format.json { render json: { errors: FastPassPresenter.new.errors_for_json(@check_in) } }
      end
    end
  end

  def update
    service = CheckInsService.new(as: current_user)
    @check_in = service.update(params[:id], params[:check_in])

    respond_to do |format|
      if @check_in.errors.empty?
        format.html { redirect_to :back, notice: 'Check in was successfully updated.' }
        format.js { render 'successfully_updated' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: @check_in.errors.values.join(', ') }
        format.json { render json: @check_in.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_batch
    service = CheckInsService.new(as: current_user, fastpass: params[:fastpass].present?)
    params[:check_in][:user_schedule_id].split(',').each do |item|
      @check_in = service.create(user_schedule_id: item, status: params[:check_in][:status])
      break if @check_in.errors.present?
    end

    respond_to do |format|
      if @check_in.persisted?
        format.html { redirect_to :back, notice: 'Check ins was successfully created.' }
        format.json { render json: { user_data: FastPassPresenter.new.for_json(@check_in) } }
      else
        format.html { redirect_to :back, alert: @check_in.errors.values.join(', ') }
        format.json { render json: { errors: FastPassPresenter.new.errors_for_json(@check_in) } }
      end
    end
  end

  def update_batch
    service = CheckInsService.new(as: current_user)
    params[:check_in][:id].split(',').each do |item|
      @check_in = service.update(item, status: params[:check_in][:status])
      break if @check_in.errors.present?
    end

    respond_to do |format|
      if @check_in.errors.empty?
        format.html { redirect_to :back, notice: 'Check ins was successfully updated.' }
        format.js { render 'successfully_updated' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.html { redirect_to :back, alert: @check_in.errors.values.join(', ') }
        format.json { render json: @check_in.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_in = CheckIn.find(params[:id])
    @check_in.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private

  def set_scope
    @scope = {
      per: (params[:per] || DEFAULT_PER_PAGE).to_i,
      page: (params[:page] || 1).to_i,
      q: params[:q],
      year: params[:year],
      month: params[:month],
      day: params[:day],
      order_charity: params[:order_charity],
      order_department: params[:order_department],
      order_name: params[:order_name],
      order_check_in: params[:order_check_in],
      order_check_out: params[:order_check_out]
    }
  end

  def volunteer_manager?
    redirect_to :root unless current_user.has_any_role? :volunteer_manager, :super_admin, :org_admin, :event_admin, :department_manager, :department_assistant
  end

  def fastpass_acessible
    redirect_to :root unless can?(:manage_fastpass, current_user)
  end

  def check_ins_service
    @service ||= CheckInsService.new(as: current_user)
  end

  def csv_service
    @csv_service ||= CsvExporterService.new
  end
end
