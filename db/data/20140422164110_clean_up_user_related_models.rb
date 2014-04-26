class CleanUpUserRelatedModels < ActiveRecord::Migration
  def self.up
    DepartmentAssistant.find_each do |r|
      r.destroy if r.user.blank?
    end
    DepartmentManager.find_each do |r|
      r.destroy if r.user.blank?
    end
    VolunteerManager.find_each do |r|
      r.destroy if r.user.blank?
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
