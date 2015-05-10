class SubaccountsController < ApplicationController
  before_filter :authenticate_user!

  def index
    respond_to do |format|
      format.html
      format.json { render json: SubaccountDatatable.new(view_context, { user: current_user }) }
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
      format.js
    end
  end

  def edit
    @subaccount = current_user.subaccounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subaccount }
    end
  end

  def create
    @subaccount = current_user.subaccounts.new(params[:user])
    @subaccount.skip_confirmation!
    respond_to do |format|
      if @subaccount.save
        format.html { redirect_to user_subaccount_path(current_user, @subaccount), notice: 'Subaccount was successfully created.' }
        format.json { render json: @subaccount, status: :created, location: @subaccount }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @subaccount.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    @subaccount = current_user.subaccounts.find(params[:id])
    @subaccount.skip_reconfirmation!
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

  def destroy
    @subaccount = User.find(params[:id])
    @subaccount.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to user_subaccounts_url(current_user) }
      format.json { head :no_content }
    end
  end

  def import
    service = Subaccounts::Importer.new(as: current_user)
    @response = service.import(params)

    if @response.not_valid_rows.present?
      flash.now[:alert] = "We need a few corrections from you in order to fully import your list..."
    elsif @response.errors.present?
      redirect_to user_subaccounts_url(current_user), alert: "#{@response.errors.join(' ,')}"
    else
      redirect_to user_subaccounts_url(current_user), notice: "#{@response.created_count} subaccounts imported."
    end
  end

end