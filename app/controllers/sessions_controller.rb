class SessionsController < Devise::SessionsController

  def create
    if params[:on_behalf].present? and user = User.find(params[:on_behalf])
      sign_in(:user, user)
      respond_with user, location: after_sign_in_path_for(user)
    else
      super
    end
  end

  protected
  
  def after_sign_in_path_for(resource)
    if resource.username.present?
      resource.sign_in_count <= 1 ? '/dashboard/user_availabilities' : root_path
    else
      flash[:notice] = 'Please enter your username'
      edit_user_registration_path
    end
  end

end