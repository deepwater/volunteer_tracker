class RenameLtDepartmentManagerToDepartmentAssistant < ActiveRecord::Migration
	def change
	    rename_table :lt_department_managers, :department_assistants
	end
end
