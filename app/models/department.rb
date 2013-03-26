class Department < ActiveRecord::Base
	has_one :department_manager
	has_one :lt_department_manager
	
	has_many :department_blocks
end
