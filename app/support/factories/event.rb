class Factories::Event

  def initialize(options = {})
    @options = options || {}
  end

  def create(attributes)
    build(nil, attributes).tap do |event|
      if event.errors.empty?
        event.save 
        save_date_range(event)
      end
      event
    end
  end

  def update(id, attributes)
    resource = Event.find(id)
    build(resource, attributes).tap do |event|
      if event.errors.empty?
        event.save 
        save_date_range(event)
      end
      event
    end
  end

  def build(resource = nil, attributes = {})
    resource ||= Event.new
    attributes = attributes.with_indifferent_access
    resource.assign_attributes(attributes)
    resource.valid?
    validate_date_range(resource)
    resource
  end

  private

  def save_date_range(entity)
    start = entity.day_of_start
    finish = entity.day_of_finish
    days_count = (finish - start).to_i + 1 # including start and finish dates
    existed_days = []

    (start..finish).each_with_index do |date, i|
      type = type_of_day(i, entity.days_for_setup.to_i, entity.days_for_tear_down.to_i, days_count)
      day = entity.days.where(date: date).first
      if day.present?
        day.update_attribute(:day_type, type)
      else
        day = entity.days.create(date: date, mday: date.day, month: date.month, year: date.year, day_type: type)
      end
      existed_days << day.id
    end
    entity.days.where('id not in (?)', existed_days).delete_all
  end

  def validate_date_range(entity)
    return if entity.errors[:day_of_start].any?
    start = entity.day_of_start
    finish = entity.day_of_finish
    days_count = (finish - start).to_i + 1 # including start and finish dates

    if days_count < (entity.days_for_setup.to_i + entity.days_for_tear_down.to_i + 1) # at least 1 day to fest
      entity.errors.add(:day_of_start, :range_is_not_valid)
    end
  end

  def type_of_day(i, setup, tear_down, days_count)
    if i < setup
      0
    elsif i < days_count - tear_down
      1
    else
      2
    end
  end

end