# == Schema Information
#
# Table name: user_charities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  charity_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserCharity < ActiveRecord::Base
	belongs_to :charity
	belongs_to :user
end
