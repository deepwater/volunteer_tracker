class Department < ActiveRecord::Base
	has_one :department_manager
	has_one :user, :through => :department_manager
end
