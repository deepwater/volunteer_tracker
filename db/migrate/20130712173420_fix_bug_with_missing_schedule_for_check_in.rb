class FixBugWithMissingScheduleForCheckIn < ActiveRecord::Migration
  def up
    CheckIn.includes(:user_schedule).find_each do |check|
      check.destroy if check.user_schedule.nil?
    end
  end

  def down
  end
end
