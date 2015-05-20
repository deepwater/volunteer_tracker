class PasswordsController < Devise::PasswordsController
  protected
  def after_resetting_password_path_for(resource)
    if resource.username.present?
      resource.sign_in_count <= 1 ? '/dashboard/user_availabilities' : authenticated_root_path
    else
      flash[:notice] = 'Please enter your username'
      edit_profile_users_path
    end
  end
end