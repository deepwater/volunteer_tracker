class Admin::EventsController < Admin::BaseController
  # GET /events
  # GET /events.json
  def index
    @events = Event.order('id')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
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

  # PUT /events/1
  # PUT /events/1.json
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

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to admin_events_url }
      format.json { head :no_content }
    end
  end
end
