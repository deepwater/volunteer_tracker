class User::DepartmentAssistant < ActiveRecord::Base
	belongs_to :user
	belongs_to :department

  class << self
    def table_name
      super.try(:gsub, 'user_', '')
    end
  end
end
