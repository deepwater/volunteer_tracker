class DepartmentBlocksUsers < ActiveRecord::Migration
	def change
		create_table :department_blocks_users, :id => false do |t|
			t.integer :user_id
			t.integer :department_block_id
		end
	end
end
