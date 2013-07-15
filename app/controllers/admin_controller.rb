class AdminController < ApplicationController
	# layout 'admin'
	before_filter :authenticate_user!
  before_filter :prepare_scope, only: [:charity_tab, :department_tab]

  DEFAULT_PER_PAGE = 10

	def index
	end

  def charity_tab
    @charities = Charity.order("name").page(@scope[:page]).per(@scope[:per])
  end

  def department_tab
    service = DepartamentService.new
    select = OpenStruct.new(
      total_slots: true,
      estimate_hours: true,
      scheduled_count: true
    )
    @departments = service.prepare_data(select, @scope)
  end

	def list
		respond_to do |format|
  		format.html
  		format.json { render json: UsersDatatable.new(view_context)}
  	end
  end

  private

  def prepare_scope
    @scope = {
      per: DEFAULT_PER_PAGE,
      page: (params[:page] || 1).to_i
    }
  end
end