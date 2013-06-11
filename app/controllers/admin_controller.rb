class AdminController < ApplicationController
	# layout 'admin'
	before_filter :authenticate_user!

	def index
	    @users        = User.all
	    @charities    = Charity.order("name")
	    @departments  = Department.order("name")
	end
end
