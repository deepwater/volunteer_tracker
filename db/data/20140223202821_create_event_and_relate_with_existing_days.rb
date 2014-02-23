class CreateEventAndRelateWithExistingDays < ActiveRecord::Migration
  def self.up
    organisation = Organisation.first
    event = Event.create(name: "Festival", route_type: 1, day_of_start: "2014-07-21 06:40:20", day_of_finish: "2014-08-01 06:40:20", organisation_id: organisation.id, days_for_setup: 5, days_for_tear_down: 4)
    Day.update_all(event_id: event.id)
  end

  def self.down
    raise IrreversibleMigration
  end
end
