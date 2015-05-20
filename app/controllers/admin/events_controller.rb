class Admin::EventsController < Admin::BaseController
  before_action :event, only: [:show, :edit, :destroy]

  def index
    @events = Event.order('id')
  end

  def show
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    service = EventsService.new(as: current_user)
    @event = service.create(params[:event])

    respond_to do |format|
      if @event.persisted?
        format.html { redirect_to admin_event_path(@event), notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    service = EventsService.new(as: current_user)
    @event = service.update(params[:id], params[:event])

    respond_to do |format|
      if @event.errors.empty?
        format.html { redirect_to admin_event_path(@event), notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to admin_events_url }
      format.json { head :no_content }
    end
  end

  private
    def event
      @event = Event.find(params[:id])
    end
end
