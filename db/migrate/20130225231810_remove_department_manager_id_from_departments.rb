class RemoveDepartmentManagerIdFromDepartments < ActiveRecord::Migration
	def change
		remove_column :departments, :department_manager_id
	end
end
