class AdminController < ApplicationController
	# layout 'admin'
	before_filter :authenticate_user!

	def index
	end

  def charity_tab
    @charities = Charity.order("name")
  end

  def department_tab
    @departments = Department.joins(:department_blocks)
    .select(
      %Q{
        departments.id, departments.name, departments.budgeted_hours,
        SUM(department_blocks.suggested_number_of_workers) as total_slots,
        SUM(extract(epoch from (cast(department_blocks.end_time as time) - cast(department_blocks.start_time as time)))/3600 * department_blocks.suggested_number_of_workers) as estimate_hours_total,
        SUM((SELECT COUNT(DISTINCT id) FROM user_schedules WHERE department_block_id = department_blocks.id)) as scheduled_count
      }
    )
    .group("departments.id").order("departments.name")
  end

	def list
		respond_to do |format|
    		format.html
    		format.json { render json: UsersDatatable.new(view_context)}
    	end
    end
end
