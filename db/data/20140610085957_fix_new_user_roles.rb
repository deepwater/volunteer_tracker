class FixNewUserRoles < ActiveRecord::Migration
  def self.up
    User.find_each { |u| u.add_role u.role unless u.has_role? u.role }
  end

  def self.down
    raise IrreversibleMigration
  end
end
