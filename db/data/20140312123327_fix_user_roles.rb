class FixUserRoles < ActiveRecord::Migration
  def self.up
    User.update_all("role = 'event_admin'", "role = 'event_administrator'")
    User.find_each do |u|
      u.add_role(u.role)
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
