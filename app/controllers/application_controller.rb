class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  # before_filter :current_organisation

  # TODO: remove username check, generate username
  def after_sign_in_path_for(resource)
    if resource.username.present?
      resource.sign_in_count <= 1 ? '/dashboard/user_availabilities' : authenticated_root_path
    else
      flash[:notice] = 'Please enter your username'
      edit_user_path
    end
  end

  def current_organisation
    @organisation ||= Organisation.find_by_subdomain!(request.subdomain.to_s.downcase) if request.subdomain.present?
  end

  def user_organisation
    current_user.organisation
  end

  def broadcast(channel, data)
    message = { channel: channel, data: data, authentication_token: configatron.faye.authentication_token }
    uri = URI.parse(configatron.faye.url)
    Net::HTTP.post_form(uri, message: message.to_json)
  end

end
