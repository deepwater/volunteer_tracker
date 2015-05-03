class Admin::CharitiesController < Admin::BaseController
  add_breadcrumb "Admin", :admin_root_path
  # GET /charities
  # GET /charities.json
  def index
    @charities = Charity.order('name')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @charities }
    end
  end

  # GET /charities/1
  # GET /charities/1.json
  def show
    @charity = Charity.find(params[:id])

    add_breadcrumb "#{@charity.name}", admin_charity_path(@charity)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @charity }
    end
  end

  # GET /charities/new
  # GET /charities/new.json
  def new
    @charity = Charity.new

    add_breadcrumb "New Charity", new_admin_charity_path

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @charity }
    end
  end

  # GET /charities/1/edit
  def edit
    @charity = Charity.find(params[:id])
  end

  # POST /charities
  # POST /charities.json
  def create
    @charity = Charity.new(params[:charity])

    respond_to do |format|
      if @charity.save
        format.html { redirect_to admin_charity_path(@charity), notice: 'Charity was successfully created.' }
        format.json { render json: @charity, status: :created, location: @charity }
      else
        format.html { render action: "new" }
        format.json { render json: @charity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /charities/1
  # PUT /charities/1.json
  def update
    @charity = Charity.find(params[:id])

    respond_to do |format|
      if @charity.update_attributes(params[:charity])
        format.html { redirect_to admin_charity_path(@charity), notice: 'Charity was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @charity.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /charities/1
  # DELETE /charities/1.json
  def destroy
    @charity = Charity.find(params[:id])
    @charity.destroy

    respond_to do |format|
      format.html { redirect_to admin_charities_url }
      format.json { head :no_content }
    end
  end
end
