class VolunteerManager < ActiveRecord::Base
  belongs_to :user
  belongs_to :department_block

end
