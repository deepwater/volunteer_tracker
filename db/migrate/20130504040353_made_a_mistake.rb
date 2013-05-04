class MadeAMistake < ActiveRecord::Migration
	def change

		drop_table :days

	    create_table :days do |t|
	      t.integer :mday
	      t.integer :month
	      t.integer :year
	      t.integer :day_type

	      t.timestamps
	    end
	end
end
