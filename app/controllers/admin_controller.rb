class AdminController < ApplicationController
	# layout 'admin'

	def index
    @users        = User.all
    @charities    = Charity.all
    @departments  = Department.all
	end
end
