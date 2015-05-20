class DepartmentBlock < ActiveRecord::Base
  resourcify
  belongs_to :department
  belongs_to :day

  has_many :user_schedules, dependent: :destroy
  has_many :users, through: :user_schedules

  has_many :volunteer_managers

  scope :ordered_by_date, -> { order('day_id').order('start_time') }

  def readable_start_time
    t = Time.parse("#{start_time} #{day.mday}/#{day.month}/#{day.year}")
    t.strftime("%l.%M%P %A %-d %B")
  end

  def start_time_12
    t = Time.parse(start_time)
    t.strftime("%l:%M%P")
  end

  def end_time_12
    t = Time.parse(end_time)
    t.strftime("%l:%M%P")
  end

  def readable_end_time
    t = Time.parse("#{end_time} #{day.mday}/#{day.month}/#{day.year}")
    t.strftime("%l.%M%P %A %-d %B")
  end

  def overlaps?(other)
    dep_block_start = Time.parse("#{self.start_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")
    dep_block_end = Time.parse("#{self.end_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}") - 1

    other_dep_block_start = Time.parse("#{other.start_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")
    other_dep_block_end = Time.parse("#{other.end_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}") - 1

    (dep_block_start - other_dep_block_end) * (other_dep_block_start - dep_block_end) >= 0
  end

  def overlap(other)
    dep_block_start = Time.parse("#{self.start_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")
    dep_block_end = Time.parse("#{self.end_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}") - 1

    other_dep_block_start = Time.parse("#{other.start_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}")
    other_dep_block_end = Time.parse("#{other.end_time} #{self.day.mday}/#{self.day.month}/#{self.day.year}") - 1

    dep_block_range = (dep_block_start.to_i..dep_block_end.to_i)
    other_dep_block_range = (other_dep_block_start.to_i..other_dep_block_end.to_i)

    (dep_block_start - other_dep_block_end) * (other_dep_block_start - dep_block_end)
  end

  def duration
    start_time = Time.parse(self.start_time)
    end_time = Time.parse(self.end_time)

    end_time - start_time
  end

  def get_user_availabilities
    availabilities = []

    # Get a list of availabilities
    @list_of_availabilities = UserAvailability.includes(
      user: :charities,
      day: {user_schedules: :department_block}
    ).where(day_id: self.day_id)

    # Select only user_availabilities that either overlap the department_block and aren't owned by department_managers and event_admin
    @list_of_availabilities.select! { |user_availability|
      self.overlaps?(user_availability) && !user_availability.user.has_role?(:department_manager) && !user_availability.user.has_role?(:event_admin)
    }

    @list_of_availabilities.each do |user_availability|
      # Get all user schedules on that day for the current user
      @user_schedules = user_availability.day.user_schedules.where("user_id = ?", user_availability.user.id)

      remaining_duration = self.duration

      if self.overlaps?(user_availability)
        user_availability_duration = Time.parse(user_availability.end_time) - Time.parse(user_availability.start_time)
        difference = remaining_duration - user_availability_duration

        remaining_duration = remaining_duration - difference
      end

      @user_schedules.each do |user_schedule|
        if self.overlaps?(user_schedule.department_block)
          remaining_duration = remaining_duration - self.overlap(user_schedule.department_block)
        end

        if user_schedule.department_block.id == self.id
          remaining_duration = 0
        end
      end

      availabilities << [user_availability,((remaining_duration / self.duration) * 100).floor] if remaining_duration > 0
    end

    availabilities
  end
end
