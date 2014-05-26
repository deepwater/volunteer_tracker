class UserSchedule < ActiveRecord::Base

  validates_uniqueness_of :user_id, scope: :department_block_id
  validate :validate_volunteers_count

  belongs_to :user
  belongs_to :department_block
  belongs_to :charity

  before_create :add_default_charity
  after_create :deliver_email, if: :has_email?
  before_destroy :unschedule_email, if: :has_email?

  has_many :check_ins, foreign_key: :user_schedule_id, primary_key: :id, dependent: :destroy


  def validate_volunteers_count
    errors.add(:base, :to_much_volunteers, count: department_block.suggested_number_of_workers) if department_block.user_schedules.size == department_block.suggested_number_of_workers
  end

  def deliver_email
    UserScheduleMailer.schedule_email(user_id, department_block_id).deliver
  end

  def unschedule_email
    UserScheduleMailer.unschedule_email(user_id, department_block_id).deliver
  end

  def has_email?
    user.email.present?
  end

  def add_default_charity
    charity_id = nil

    if self.user.user_charities.any?
      charity_id = self.user.user_charities.first.charity.id
    end

    self.charity_id ||= charity_id
  end
  
end
