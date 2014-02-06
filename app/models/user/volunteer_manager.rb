class User::VolunteerManager < ActiveRecord::Base
	belongs_to :user
	belongs_to :department_block

  class << self
    def table_name
      super.try(:gsub, 'user_', '')
    end
  end
end
