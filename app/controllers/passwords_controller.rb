class PasswordsController < Devise::PasswordsController
  protected
  def after_resetting_password_path_for(resource)
    if resource.username.present?
      resource.sign_in_count <= 1 ? '/dashboard/user_availabilities' : root_path
    else
      flash[:notice] = 'Please enter your username'
      edit_user_registration_path
    end
  end
end