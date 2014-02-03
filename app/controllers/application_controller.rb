class ApplicationController < ActionController::Base
  include UrlHelper
	protect_from_forgery

	def after_sign_in_path_for(resource)
	  resource.sign_in_count <= 1 ? '/dashboard/user_availabilities' : root_path
	end

  def current_organisation
    @organisation ||= Organisation.find_by_subdomain!(request.subdomain.to_s.downcase)
  end

end
