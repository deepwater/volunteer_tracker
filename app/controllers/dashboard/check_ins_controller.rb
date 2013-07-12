class Dashboard::CheckInsController < DashboardController
  DEFAULT_PER_PAGE = 10
  before_filter :set_scope, only: [:scheduled, :active, :inactive]
  before_filter :check_ability, only: [:scheduled, :active, :inactive]

  def index
    @check_ins = CheckIn.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @check_ins }
    end
  end

  def show
    @check_in = CheckIn.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @check_in }
    end
  end

  def scheduled
    @service = ScheduledCheckInsService.new(as: current_user)
    @results = @service.prepare_scheduled_data(@scope)
  end

  def active
    @results = check_ins_service.prepare_check_ins_data(:active, @scope)
  end

  def inactive
    @results = check_ins_service.prepare_check_ins_data(:inactive, @scope)
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

  def create
    @check_in = CheckIn.new(params[:check_in])

    respond_to do |format|
      if @check_in.save
        format.html { redirect_to :back, notice: 'Check in was successfully created.' }
        format.json { render json: @check_in, status: :created, location: @check_in }
      else
        format.html { render action: "new" }
        format.json { render json: @check_in.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @check_in = CheckIn.find(params[:id])

    respond_to do |format|
      if @check_in.update_attributes(params[:check_in])
        format.html { redirect_to :back, notice: 'Check in was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
      page: (params[:page] || 1).to_i
    }
  end

  def check_ability
    redirect_to :root unless current_user.role?(:volunteer_manager)
  end

  def check_ins_service
    @service ||= CheckInsService.new(as: current_user)
  end
end
