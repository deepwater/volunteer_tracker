# == Schema Information
#
# Table name: department_blocks
#
#  id                          :integer          not null, primary key
#  suggested_number_of_workers :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  department_id               :integer
#  name                        :text
#  day_id                      :integer
#  start_time                  :string(255)
#  end_time                    :string(255)
#

require 'test_helper'

class DepartmentBlockTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
