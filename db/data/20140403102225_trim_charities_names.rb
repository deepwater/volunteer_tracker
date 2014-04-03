class TrimCharitiesNames < ActiveRecord::Migration
  def self.up
    Charity.all.each do |c|
      c.name.strip!
      c.save
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
