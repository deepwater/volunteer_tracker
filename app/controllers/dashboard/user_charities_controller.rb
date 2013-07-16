class Dashboard::UserCharitiesController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@user_charity = UserCharity.new
    @charities = Charity.order('name')
  end


  def create
  	UserCharity.where(:user_id => current_user.id).delete_all

    @user_charity = UserCharity.new(params[:user_charity])
    
  	if @user_charity.save
  		redirect_to dashboard_index_path
  	end
  end
end