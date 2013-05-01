# == Schema Information
#
# Table name: volunteer_managers
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  department_block_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class VolunteerManager < ActiveRecord::Base
	belongs_to :user
	belongs_to :department_block
end
