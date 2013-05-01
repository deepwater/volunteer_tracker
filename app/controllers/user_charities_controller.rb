class UserCharitiesController < ApplicationController
  # GET /user_charities
  # GET /user_charities.json
  def index
    @user_charities = UserCharity.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_charities }
    end
  end

  # GET /user_charities/1
  # GET /user_charities/1.json
  def show
    @user_charity = UserCharity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_charity }
    end
  end

  # GET /user_charities/new
  # GET /user_charities/new.json
  def new
    @user_charity = UserCharity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_charity }
    end
  end

  # GET /user_charities/1/edit
  def edit
    @user_charity = UserCharity.find(params[:id])
  end

  # POST /user_charities
  # POST /user_charities.json
  def create
    @user_charity = UserCharity.new(params[:user_charity])

    respond_to do |format|
      if @user_charity.save
        format.html { redirect_to @user_charity, notice: 'User charity was successfully created.' }
        format.json { render json: @user_charity, status: :created, location: @user_charity }
      else
        format.html { render action: "new" }
        format.json { render json: @user_charity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_charities/1
  # PUT /user_charities/1.json
  def update
    @user_charity = UserCharity.find(params[:id])

    respond_to do |format|
      if @user_charity.update_attributes(params[:user_charity])
        format.html { redirect_to @user_charity, notice: 'User charity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_charity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_charities/1
  # DELETE /user_charities/1.json
  def destroy
    @user_charity = UserCharity.find(params[:id])
    @user_charity.destroy

    respond_to do |format|
      format.html { redirect_to user_charities_url }
      format.json { head :no_content }
    end
  end
end
