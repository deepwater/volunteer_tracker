class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  before_filter :current_organisation

  def after_sign_in_path_for(resource)
    if resource.username.present?
      resource.sign_in_count <= 1 ? '/dashboard/user_availabilities' : root_url(subdomain: user_organisation.try(:subdomain))
    else
      edit_user_registration_path(subdomain: user_organisation.try(:subdomain))
    end
  end

  def current_organisation
    @organisation ||= Organisation.find_by_subdomain!(request.subdomain.to_s.downcase) if request.subdomain.present?
  end

  def user_organisation
    current_user.organisation
  end

end
