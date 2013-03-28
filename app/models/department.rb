class Department < ActiveRecord::Base
	has_many :department_manager
	has_many :lt_department_manager
	
	has_many :department_blocks
end
