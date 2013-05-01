# == Schema Information
#
# Table name: charities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Charity < ActiveRecord::Base

has_many :user_charities
has_many :users, :through => :user_charities
end
