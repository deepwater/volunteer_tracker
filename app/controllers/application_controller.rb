class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  # before_filter :current_organisation

  def current_organisation
    @organisation ||= Organisation.find_by_subdomain!(request.subdomain.to_s.downcase) if request.subdomain.present?
  end

  def user_organisation
    current_user.organisation
  end

end
