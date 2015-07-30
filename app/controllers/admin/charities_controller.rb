class Admin::CharitiesController < Admin::BaseController
  before_action :charity, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: CharityDatatable.new(view_context) }
    end
  end

  def show
  end

  def new
    @charity = Charity.new
  end

  def edit
  end

  def create
    @charity = Charity.new(charity_params)

    respond_to do |format|
      if @charity.save
        format.html { redirect_to [:admin, @charity], flash: { success: 'Charity was successfully created.' } }
        format.json { render :show, status: :created, location: [:admin, @charity] }
      else
        format.html { render :new }
        format.json { render json: @charity.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @charity.update(charity_params)
        format.html { redirect_to admin_root_url(anchor: 'charities'), flash: { success: 'Charity was successfully updated.' } }
        format.json { render :show, status: :ok, location: [:admin, @charity] }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @charity.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @charity.destroy
    respond_to do |format|
      format.html { redirect_to admin_root_url(anchor: 'charities'), flash: { success: 'Charity was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end 

  private
    def charity
      @charity = Charity.find(params[:id])
    end

    def charity_params
      params.require(:charity).permit(:name)
    end
end
