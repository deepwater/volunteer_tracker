class CharitiesController < ApplicationController
  # GET /charities
  # GET /charities.json
  def index
    @charities = Charity.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @charities }
    end
  end

  # GET /charities/1
  # GET /charities/1.json
  def show
    @charity = Charity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @charity }
    end
  end
end
