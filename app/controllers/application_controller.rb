class ApplicationController < ActionController::Base
	protect_from_forgery

	def after_sign_in_path_for(resource)
	  resource.sign_in_count <= 1 ? '/dashboard/user_availabilities' : root_path
	end
end
