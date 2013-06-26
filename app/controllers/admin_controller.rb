class AdminController < ApplicationController
	# layout 'admin'
	before_filter :authenticate_user!

	def index
	    @charities    = Charity.order("name")
	    @departments  = Department.order("name")
	end

	def list
		respond_to do |format|
    		format.html
    		format.json { render json: UsersDatatable.new(view_context)}
    	end
    end
end
