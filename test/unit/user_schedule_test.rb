# == Schema Information
#
# Table name: user_schedules
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  department_block_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class UserScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
