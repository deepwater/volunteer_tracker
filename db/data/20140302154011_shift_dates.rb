class ShiftDates < ActiveRecord::Migration
  def self.up
    Day.all.map do |day|
      if day.mday == 1 && day.month == 8
        day.mday = 31
        day.month = 7
      else
        day.mday -= 1
      end
      day.date = Date.new(day.year, day.month, day.mday)
      day.save!
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
