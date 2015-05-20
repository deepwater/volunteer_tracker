class Flag < ActiveRecord::Base

  belongs_to :check_in
  belongs_to :user
  after_create :deliver_email

  def deliver_email
    FlagMailer.flag_email(self).deliver
  end
end
