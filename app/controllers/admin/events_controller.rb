class Admin::EventsController < Admin::BaseController
  before_action :event, only: [:show, :edit, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: EventDatatable.new(view_context) }
    end
  end

  def show
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    service = EventsService.new(as: current_user)
    @event = service.create(event_params)

    respond_to do |format|
      if @event.persisted?
        format.html { redirect_to [:admin, @event], flash: { success: 'Event was successfully created.' } }
        format.json { render :show, status: :created, location: [:admin, @event] }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    service = EventsService.new(as: current_user)
    @event = service.update(params[:id], event_params)

    respond_to do |format|
      if @event.errors.empty?
        format.html { redirect_to [:admin, @event], flash: { success: 'Event was successfully updated.' } }
        format.json { render :show, status: :ok, location: [:admin, @event] }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to admin_root_url(anchor: 'events'), flash: { success: 'Event was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  private
    def event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit!
    end
end
