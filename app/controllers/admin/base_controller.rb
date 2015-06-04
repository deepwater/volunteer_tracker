class Admin::BaseController < ApplicationController
	before_filter :authenticate_user!
  before_filter :authenticate_admin
  before_filter :prepare_scope, only: [:charity_tab, :department_tab, :event_tab, :organisation_tab]

  DEFAULT_PER_PAGE = 10

  def index
  end

  def charity_tab
    @charities = Charity.order("charities.name").page(@scope[:page]).per(@scope[:per])
    ids = @charities.map(&:id)
    @schedules = UserSchedule.where(charity_id: ids)
    .joins("LEFT OUTER JOIN check_ins ON check_ins.user_schedule_id = user_schedules.id")
    .where("check_ins.status = '2'")
    .select("user_schedules.charity_id, SUM(extract(epoch from (check_ins.check_out_time - check_ins.created_at))) as total_seconds")
    .group("user_schedules.charity_id").inject({}) { |h, o| h.merge!({o.charity_id => o.total_seconds.to_i/3600}) }
  end

  def event_tab
    @events = Event.order(:id).page(@scope[:page]).per(@scope[:per])
  end

  def organisation_tab
    @organisations = Organisation.order(:id).page(@scope[:page]).per(@scope[:per])
  end

  def department_tab
    service = DepartmentService.new
    select = OpenStruct.new(
      total_slots: true,
      estimate_hours: true,
      scheduled_count: true
    )
    @departments = service.prepare_data(select, @scope)
    @volunteer_hours = service.volunteer_hours_progress(@departments.map(&:id))
  end

  private

  # TODO: Tidy up pagination on whole app
  def prepare_scope
    @scope = {
      per: DEFAULT_PER_PAGE,
      page: (params[:page] || 1).to_i
    }
  end

  def authenticate_admin
    redirect_to authenticated_root_path unless current_user.has_any_role? :super_admin, :org_admin, :event_admin
  end
end