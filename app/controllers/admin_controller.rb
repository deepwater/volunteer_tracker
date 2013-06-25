class AdminController < ApplicationController
	# layout 'admin'
	before_filter :authenticate_user!

	def index
	    @users        = User.paginate(:page => params[:page], :per_page => 1)
	    @charities    = Charity.order("name")
	    @departments  = Department.order("name")
	end
end
