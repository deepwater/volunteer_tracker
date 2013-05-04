class RenameTypeInDays < ActiveRecord::Migration
	def change
		change_column :days, :type, :day_type
	end	
end
