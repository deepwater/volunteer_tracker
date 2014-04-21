class SessionsController < Devise::SessionsController

  def create
    if params[:on_behalf].present? and resource = User.find(params[:on_behalf])
      sign_in(:user, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    elsif resource.subaccount?
      resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      sign_in(:user, resource.master)
      respond_with resource.master, location: after_sign_in_path_for(resource.master)
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