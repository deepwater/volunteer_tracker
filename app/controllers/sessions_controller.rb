class SessionsController < Devise::SessionsController

  def create
    if params[:on_behalf].present? and resource = User.find(params[:on_behalf])
      sign_in(:user, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    elsif resource = warden.authenticate!(auth_options) and resource.subaccount?
      set_flash_message(:notice, :signed_in)
      sign_in(:user, resource.master)
      respond_with resource.master, location: after_sign_in_path_for(resource.master)
    else
      super
    end
  end

end