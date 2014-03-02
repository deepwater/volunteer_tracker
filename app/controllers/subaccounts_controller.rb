class SubaccountsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @master = User.find(params[:user_id])
    @subaccounts = @master.subaccounts

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subaccounts }
    end
  end

  def show
    @subaccount = User.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subaccount }
    end
  end

  def new
    @subaccount = current_user.subaccounts.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subaccount }
    end
  end

  def edit
    @subaccount = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subaccount }
    end
  end

  def create
    @subaccount = User.new(params[:user])
    @subaccount.skip_confirmation!
    respond_to do |format|
      if @subaccount.save
        format.html { redirect_to user_subaccount_path(current_user, @subaccount), notice: 'Subaccount was successfully created.' }
        format.json { render json: @subaccount, status: :created, location: @subaccount }
      else
        format.html { render action: "new" }
        format.json { render json: @subaccount.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subaccounts/1
  # PUT /subaccounts/1.json
  def update
    @subaccount = User.find(params[:id])

    respond_to do |format|
      if @subaccount.update_attributes(params[:user])
        format.html { redirect_to user_subaccount_path(current_user, @subaccount), notice: 'Subaccount was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subaccount.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subaccounts/1
  # DELETE /subaccounts/1.json
  def destroy
    @subaccount = User.find(params[:id])
    @subaccount.destroy

    respond_to do |format|
      format.html { redirect_to user_subaccounts_url(current_user) }
      format.json { head :no_content }
    end
  end



end