class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def edit
    @user = User.find(current_user.id)
  end
end
