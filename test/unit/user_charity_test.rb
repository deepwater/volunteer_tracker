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

require 'test_helper'

class UserCharityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
