class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  # before_filter :current_organisation

  def after_sign_in_path_for(resource)
    if resource.username.present?
      resource.sign_in_count <= 1 ? '/dashboard/user_availabilities' : root_path
    else
      flash[:notice] = 'Please enter your username'
      edit_user_path(resource)
    end
  end

  def current_organisation
    @organisation ||= Organisation.find_by_subdomain!(request.subdomain.to_s.downcase) if request.subdomain.present?
  end

  def user_organisation
    current_user.organisation
  end

end
