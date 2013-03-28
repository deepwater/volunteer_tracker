class Department < ActiveRecord::Base
	has_many :department_managers
	has_many :lt_department_managers
	
	has_many :department_blocks
end
