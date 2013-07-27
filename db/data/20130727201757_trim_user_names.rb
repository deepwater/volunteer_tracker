class TrimUserNames < ActiveRecord::Migration
  def self.up
    User.find_each do |u|
      u.first_name = u.first_name.strip
      u.last_name = u.last_name.strip
      u.save
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
