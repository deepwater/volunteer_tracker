class TrimCharitiesNames < ActiveRecord::Migration
  def self.up
    Charity.find_each do |c|
      c.name = c.name.strip
      c.save
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
