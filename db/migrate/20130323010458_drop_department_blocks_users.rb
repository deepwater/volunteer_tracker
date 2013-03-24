class DropDepartmentBlocksUsers < ActiveRecord::Migration
	def change
		drop_table :department_blocks_users
	end
end
