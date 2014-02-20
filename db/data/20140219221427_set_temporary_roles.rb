class SetTemporaryRoles < ActiveRecord::Migration
  def self.up
    users = User.where(email: %w[bwj@bjenkins.com craig_miner@ajg.com joann@gilroygarlicfestival.com deanna.franklin@rabobank.com brianbowe@verizon.net jessica@omgmediagroup.com wanzong@gmail.com] )
    users.each do |user|
      user.add_role(:super_admin)
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
