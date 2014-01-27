class DeleteEventTimeslots < ActiveRecord::Migration
  def change
    drop_table :event_timeslots

  end
end
