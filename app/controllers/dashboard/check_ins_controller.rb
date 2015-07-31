class Dashboard::CheckInsController < DashboardController
  before_filter :volunteer_manager?, only: [:scheduled, :active, :inactive]
  before_filter :fastpass_acessible, only: [:fastpass, :fastpass_out]

  def show
    @check_in = CheckIn.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @check_in }
    end
  end

  def manage
  end

  def scheduled
    day = Day.find params[:day_id]
    respond_to do |format|
      format.html
      format.json { render json: ScheduledVolunteerDatatable.new(view_context, { user: current_user, day: day }) }
    end
  end

  def active
    day = Day.find params[:day_id]
    respond_to do |format|
      format.html
      format.json { render json: ActiveVolunteerDatatable.new(view_context, { user: current_user, day: day }) }
    end
  end

  def inactive
    day = Day.find params[:day_id]
    respond_to do |format|
      format.html
      format.json { render json: InactiveVolunteerDatatable.new(view_context, { user: current_user, day: day }) }
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
    @check_in = service.check_out(check_in_params[:user_schedule_id])

    if @check_in.is_a? String
      render json: { errors: [*@check_in] }
    else
      broadcast @check_in, 'check_out'
      render json: { user_data: FastPassPresenter.new.for_json(@check_in) }
    end
  end

  def is_accessible
    service = CheckInsService.new(as: current_user)
    render json: { status: :success, response: service.resourse_is_accessible_for_accessor(params[:id]) }
  end

  def create
    service = CheckInsService.new(as: current_user, fastpass: params[:fastpass].present?)
    @check_in = service.create(check_in_params)
    anchor = cookies.delete(:tabs_anchor)
    back_path = (request.referer && anchor) ? request.referer + '#' + anchor : :back

    respond_to do |format|
      if @check_in.present? && @check_in.persisted?
        broadcast @check_in, 'check_in'

        format.html { redirect_to back_path, flash: { success: 'Check in was successfully created.' } }
        format.json { render json: { user_data: FastPassPresenter.new.for_json(@check_in) } }
      else
        format.html { redirect_to back_path, flash: { error: @check_in.errors.values.join(', ') } }
        format.json { render json: { errors: FastPassPresenter.new.errors_for_json(@check_in) } }
      end
    end
  end

  def update
    service = CheckInsService.new(as: current_user)
    @check_in = service.update(params[:id], check_in_params)
    anchor = cookies.delete(:tabs_anchor)
    back_path = (request.referer && anchor) ? request.referer + '#' + anchor : :back

    respond_to do |format|
      if @check_in.errors.empty?
        broadcast @check_in, 'check_out'

        format.html { redirect_to back_path, flash: { success: 'Check in was successfully updated.' } }
        format.js { render 'successfully_updated' }
        format.json { head :no_content }
      else
        format.html { redirect_to back_path, flash: { error: @check_in.errors.values.join(', ') } }
        format.json { render json: @check_in.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_batch
    service = CheckInsService.new(as: current_user, fastpass: params[:fastpass].present?)
    check_in_params[:user_schedule_id].split(',').each do |item|
      @check_in = service.create(user_schedule_id: item, status: check_in_params[:status])
      break if @check_in.errors.present?
      broadcast(@check_in, 'check_in') if @check_in.errors.empty?
    end
    anchor = cookies.delete(:tabs_anchor)
    back_path = (request.referer && anchor) ? request.referer + '#' + anchor : :back

    respond_to do |format|
      if @check_in.present? && @check_in.persisted?
        format.html { redirect_to back_path, flash: { success: 'Check ins was successfully created.' } }
        format.json { render json: { user_data: FastPassPresenter.new.for_json(@check_in) } }
      else
        format.html { redirect_to back_path, flash: { error: @check_in.errors.values.join(', ') } }
        format.json { render json: { errors: FastPassPresenter.new.errors_for_json(@check_in) } }
      end
    end
  end

  def update_batch
    service = CheckInsService.new(as: current_user)
    check_in_params[:id].split(',').each do |item|
      @check_in = service.update(item, check_in_params)
      break if @check_in.errors.present?
      broadcast(@check_in, 'check_out') if @check_in.errors.empty?
    end
    anchor = cookies.delete(:tabs_anchor)
    back_path = (request.referer && anchor) ? request.referer + '#' + anchor : :back

    respond_to do |format|
      if @check_in.present? && @check_in.errors.empty?
        format.html { redirect_to back_path, flash: { success: 'Check ins was successfully updated.' } }
        format.js { render 'successfully_updated' }
        format.json { head :no_content }
      else
        format.html { redirect_to back_path, flash: { error: (@check_in ? @check_in.errors.values.join(', ') : 'Volunteers were not selected') } }
        format.json { render json: @check_in.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @check_in = CheckIn.find(params[:id])
    @check_in.destroy
    anchor = cookies.delete(:tabs_anchor)
    back_path = (request.referer && anchor) ? request.referer + '#' + anchor : :back

    respond_to do |format|
      format.html { redirect_to back_path }
      format.json { head :no_content }
    end
  end

  private

    def broadcast(obj, event_type)
      super "/channels/#{configatron.faye.channels.check_ins}", \
            { 
              event_type: event_type, 
              id: obj.id,
              data: VolunteerDatatable.new(view_context).html_row_from_record(obj)
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

    def check_in_params
      params.require(:check_in).permit!
    end
end
