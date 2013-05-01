# == Schema Information
#
# Table name: user_availabilities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  day_id     :integer
#  time       :string(255)
#

class UserAvailability < ActiveRecord::Base
	belongs_to :user
end
