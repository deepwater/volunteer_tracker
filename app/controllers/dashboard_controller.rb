class DashboardController < ApplicationController
	# layout 'dashboard'
	before_filter :authenticate_user!

	def index
		@user_schedules = current_user.user_schedules.limit(5)

    	@active = CheckIn.where(status: "1")
    	@inactive = CheckIn.where(status: "2")

	    # CREATE A BLANK ARRAY FOR STORING SCHEDULES
	    @scheduled = []

	    # GET ALL THE USER SCHEDULES AND CHECK THEM IN THE ARRAY
	    Day.all.each do |day|
	      @scheduled << day.user_schedules
	    end

	    # FLATTEN THE ARRAY
	    @scheduled.flatten!

	    # REMOVE SCHEDULES THAT ARE CHECKED IN
	    @scheduled.select!{ |user_schedule|
	      !CheckIn.find_by_user_schedule_id(user_schedule.id)
	    }

	    # ARRANGE THE USER_SCHEDULES BY DATE
	    @scheduled.sort_by!{ |user_schedule|
	      t = Time.parse("#{user_schedule.department_block.end_time} #{user_schedule.department_block.day.mday}/#{user_schedule.department_block.day.month}/#{user_schedule.department_block.day.year}")
	    }

		# if current_user
		# @check_in_schedules = 
	end
end
