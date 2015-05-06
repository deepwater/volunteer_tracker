class DataChanges2015 < ActiveRecord::Migration
  def self.up
  	UserSchedule.delete_all
  	UserAvailability.delete_all
  	CheckIn.delete_all
  	Day.last.destroy

  	Day.all.map do |day|
      day.year += 1
      day.mday -= 1
      day.date = Time.new(day.year, day.month, day.mday)
      day.save!
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
