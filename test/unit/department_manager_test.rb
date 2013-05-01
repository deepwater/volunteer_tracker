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

require 'test_helper'

class DepartmentManagerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
