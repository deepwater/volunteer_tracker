# == Schema Information
#
# Table name: department_managers
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class DepartmentManager < ActiveRecord::Base
	belongs_to :user
	belongs_to :department
end
