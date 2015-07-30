class Dashboard::FlagsController < DashboardController
  # TODO: find out do we still need flags
  def index
    @flags = Flag.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @flags }
    end
  end

  def show
    @flag = Flag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @flag }
    end
  end

  def new
    @flag = Flag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @flag }
    end
  end

  def edit
    @flag = Flag.find(params[:id])
  end

  def create
    @flag = Flag.new(params[:flag])

    respond_to do |format|
      if @flag.save
        format.html { redirect_to :back, flash: { success: 'Flag was successfully created.' } }
        format.json { render json: @flag, status: :created, location: @flag }
      else
        format.html { render action: 'new' }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @flag = Flag.find(params[:id])

    respond_to do |format|
      if @flag.update_attributes(params[:flag])
        format.html { redirect_to :back, flash: { success: 'Flag was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @flag = Flag.find(params[:id])
    @flag.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
end
