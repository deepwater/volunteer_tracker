class OrganisationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :current_organisation

  def show
  end
end
