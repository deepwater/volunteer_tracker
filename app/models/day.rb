class Day < ActiveRecord::Base

  default_scope -> { order('date ASC') }

  has_many :user_availabilities
  has_many :department_blocks
  has_many :user_schedules, through: :department_blocks
  belongs_to :event

  def user_scheduled?(user)
    department_blocks.joins("
      LEFT OUTER JOIN user_schedules ON user_schedules.department_block_id = department_blocks.id
    ").where("user_schedules.user_id = ?", user.try(:id)).exists?
  end

  def user_available?(user)
    user_availabilities.where("user_id = ?", user.try(:id)).exists?
  end

  def user_available_by_user(user)
    user_availabilities.where("user_id = ?", user.try(:id)).first
  end

  def to_date
    Date.new(year, month, mday)
  end

  def day_name
    t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
    return t.strftime("%a")
  end

  def short_date
    t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
    return t.strftime("%m/%d")
  end

  def safe_short_date
    t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
    return t.strftime('%m%d')
  end

  def long_date
    t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
    return t.strftime("%a %b %e %Y")
  end

  def short_date_with_day
    t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
    return t.strftime("%a %b %e")
  end

  def short_date_with_long_day
    t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
    return t.strftime("%A, %B %e")
  end
end