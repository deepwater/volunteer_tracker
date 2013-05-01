class UserAvailabilitiesController < ApplicationController
  # GET /user_availabilities
  # GET /user_availabilities.json
  def index
    @user_availabilities = UserAvailability.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_availabilities }
    end
  end

  # GET /user_availabilities/1
  # GET /user_availabilities/1.json
  def show
    @user_availability = UserAvailability.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_availability }
    end
  end

  # GET /user_availabilities/new
  # GET /user_availabilities/new.json
  def new
    @user_availability = UserAvailability.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_availability }
    end
  end

  # GET /user_availabilities/1/edit
  def edit
    @user_availability = UserAvailability.find(params[:id])
  end

  # POST /user_availabilities
  # POST /user_availabilities.json
  def create
    @user_availability = UserAvailability.new(params[:user_availability])

    respond_to do |format|
      if @user_availability.save
        format.html { redirect_to @user_availability, notice: 'User availability was successfully created.' }
        format.json { render json: @user_availability, status: :created, location: @user_availability }
      else
        format.html { render action: "new" }
        format.json { render json: @user_availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_availabilities/1
  # PUT /user_availabilities/1.json
  def update
    @user_availability = UserAvailability.find(params[:id])

    respond_to do |format|
      if @user_availability.update_attributes(params[:user_availability])
        format.html { redirect_to @user_availability, notice: 'User availability was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_availabilities/1
  # DELETE /user_availabilities/1.json
  def destroy
    @user_availability = UserAvailability.find(params[:id])
    @user_availability.destroy

    respond_to do |format|
      format.html { redirect_to user_availabilities_url }
      format.json { head :no_content }
    end
  end
end
