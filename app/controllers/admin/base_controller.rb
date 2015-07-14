class Admin::BaseController < ApplicationController
	before_filter :authenticate_user!
  before_filter :authenticate_admin

  def index
  end

  private

  def authenticate_admin
    redirect_to root_path unless current_user.has_any_role? :super_admin, :org_admin, :event_admin
  end
end