class CreateEventTimeslots < ActiveRecord::Migration
  def change
    create_table :event_timeslots do |t|
      t.integer :utc_date

      t.timestamps
    end
  end
end
