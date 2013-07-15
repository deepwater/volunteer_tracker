class FixProblemWithMissingDepBlocks < ActiveRecord::Migration
  def self.up
    us = UserSchedule.where("department_block_id IS NOT null AND department_block_id != 0").includes(:department_block)
    us.reject { |s| s.department_block.present? }.map(&:destroy)
  end

  def self.down
    raise IrreversibleMigration
  end
end
