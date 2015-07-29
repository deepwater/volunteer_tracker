class Admin::OrganisationsController < Admin::BaseController
  before_action :organisation, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: OrganisationDatatable.new(view_context) }
    end
  end

  def show
  end

  def new
    @organisation = Organisation.new
  end

  def edit
  end

  def create
    @organisation = Organisation.new(organisation_params)

    respond_to do |format|
      if @organisation.save
        format.html { redirect_to [:admin, @organisation], notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @organisation] }
      else
        format.html { render action: "new" }
        format.json { render json: @organisation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @organisation.update_attributes(organisation_params)
        format.html { redirect_to [:admin, @organisation], notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @organisation] }
      else
        format.html { render action: "edit" }
        format.json { render json: @organisation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @organisation.destroy

    respond_to do |format|
      format.html { redirect_to admin_root_url(anchor: 'organisations', notice: 'Organization was successfully destroyed.') }
      format.json { head :no_content }
    end
  end

  private
    def organisation
      @organisation = Organisation.find(params[:id])
    end

    def organisation_params
      params.require(:organisation).permit!
    end
end
