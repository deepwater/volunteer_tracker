class CharitiesController < ApplicationController
  
  def index
    @charities = Charity.order('name')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @charities }
    end
  end

  def show
    @charity = Charity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @charity }
    end
  end
end
