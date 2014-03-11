class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(resource)
    welcome_url(subdomain: resource.try(:organisation).try(:subdomain))
  end
end