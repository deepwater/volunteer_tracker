class Dashboard::UserCharitiesController < ApplicationController

  def index
  	@user_charity = UserCharity.new
    @charities = Charity.all
  end


  def create
  	UserCharity.where(:user_id => current_user.id).delete_all

    @user_charity = UserCharity.new(params[:user_charity])
    
  	if @user_charity.save
  		redirect_to "/dashboard/registration_complete"
  	end
  end
end