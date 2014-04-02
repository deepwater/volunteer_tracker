class MarkAllUsersAsAdult < ActiveRecord::Migration
  def self.up
    User.update_all(adult: true)
  end

  def self.down
    raise IrreversibleMigration
  end
end
