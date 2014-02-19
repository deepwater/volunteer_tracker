class SetTemporaryRoles < ActiveRecord::Migration
  def self.up
    users = User.where(email: %w[brianbowe@verizon.net jessica@omgmediagroup.com brianbowe@verizon.net] )
    users.each do |user|
      user.add_role(:super_admin)
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
