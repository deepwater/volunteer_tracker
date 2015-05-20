class Admin::OrganisationsController < Admin::BaseController
  before_action :organisation, only: [:show, :edit, :update, :destroy]

  def index
    @organisations = Organisation.order('name')
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
        format.html { redirect_to admin_organisation_path(@organisation), notice: 'Organisation was successfully created.' }
        format.json { render json: @organisation, status: :created, location: @organisation }
      else
        format.html { render action: "new" }
        format.json { render json: @organisation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @organisation.update_attributes(organisation_params)
        format.html { redirect_to admin_organisation_path(@organisation), notice: 'Organisation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @organisation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @organisation.destroy

    respond_to do |format|
      format.html { redirect_to admin_organisations_url }
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
