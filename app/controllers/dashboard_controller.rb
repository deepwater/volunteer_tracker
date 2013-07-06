class DashboardController < ApplicationController
	# layout 'dashboard'
	before_filter :authenticate_user!

	def index
		@user_schedules = current_user.user_schedules.limit(5)

		if can? :manage, CheckIn

	    	@scheduled = []

			# IF THE USER IS A VOLUNTEER MANAGER & ASSIGNED
		    if current_user.role? :volunteer_manager and !current_user.volunteer_manager.nil?
		    	@scheduled = UserSchedule.where(department_block_id: current_user.volunteer_manager.department_block.id)

		    # IF THE USER IS A DEPARTMENT ASSISTANT & ASSIGNED
		    elsif current_user.role? :department_assistant and !current_user.department_assistant.nil?
		    	@department_blocks = DepartmentBlock.where(department_id: current_user.department_assistant.department.id)

		    	@department_blocks.each do |department_block|
		    		@scheduled << department_block.user_schedules
		    	end

		    #IF THE USER IS A DEPARTMENT MANAGER & ASSIGNED
		    elsif current_user.role? :department_manager and !current_user.department_manager.nil?
		    	@department_blocks = DepartmentBlock.where(department_id: current_user.department_manager.department.id)

		    	@department_blocks.each do |department_block|
		    		@scheduled << department_block.user_schedules
		    	end

		    # IF THE USER IS AN EVENT ADMINISTRATOR
		    elsif current_user.role? :event_administrator
		    	@scheduled = UserSchedule.all
		    end

		    @scheduled.flatten!

	    	@active = []
			@inactive = []

	    	@scheduled.each do |user_schedule|
	    		user_schedule.check_ins.each do |check_in|
    				@active << check_in if check_in.status == "1"
    			 	@inactive << check_in if check_in.status == "2" 
	    		end
	    	end

		    # REMOVE SCHEDULES THAT ARE CHECKED IN
		    @scheduled.select!{ |user_schedule|
		      !CheckIn.find_by_user_schedule_id(user_schedule.id)
		    }

		    # ARRANGE THE USER_SCHEDULES BY DATE
		    if @scheduled.length > 0
			    @scheduled.sort_by!{ |user_schedule|
			      put "TEST #{user_schedule}"
			      put "TEST 2 #{user_schedule.department_block}"
			      t = Time.parse("#{user_schedule.department_block.end_time} #{user_schedule.department_block.day.mday}/#{user_schedule.department_block.day.month}/#{user_schedule.department_block.day.year}")
			    }
		   	end

		   	if @active.length > 0
			    @active.sort_by!{ |check_in|
			      t = Time.parse("#{check_in.user_schedule.department_block.end_time} #{check_in.user_schedule.department_block.day.mday}/#{check_in.user_schedule.department_block.day.month}/#{check_in.user_schedule.department_block.day.year}")
			    }
			end

			if @inactive.length > 0
			    @inactive.sort_by!{ |check_in|
			      t = Time.parse("#{check_in.user_schedule.department_block.end_time} #{check_in.user_schedule.department_block.day.mday}/#{check_in.user_schedule.department_block.day.month}/#{check_in.user_schedule.department_block.day.year}")
			    }
			end
		end
	end
end
