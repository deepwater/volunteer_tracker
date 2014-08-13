class Factories::CheckIn

  def initialize(options = {})
    @options = options || {}
  end

  def create(attributes)
    build(nil, attributes).tap do |check_in|
      validate_user_schedule_existance(check_in)
      validate_user_check_in_existance(check_in)
      validate_check_in_date(check_in) if @options[:fastpass]
      check_out_existed_check_ins(check_in) if @options[:fastpass]
      check_in.save if check_in.errors.empty?
      check_in
    end
  end

  def update(id, attributes)
    resource = id.present? ? CheckIn.find(id) : CheckIn.find_by_user_schedule_id(attributes["user_schedule_id"])
    build(resource, attributes).tap do |check_in|
      validate_user_schedule_existance(check_in)
      if check_in.status_changed?
        validate_user_check_in_existance(check_in) if check_in.status == '1'
        validate_user_check_out_existance(check_in) if check_in.status == '2'
      end
      check_in.save if check_in.errors.empty?
      check_in
    end
  end

  def build(resource = nil, attributes = {})
    resource ||= CheckIn.new
    attributes = attributes.with_indifferent_access
    attrs = filter_attributes(attributes)
    attrs = format_dates(attrs)
    resource.assign_attributes(attrs)
    resource.valid?
    validate_dates(resource)
    resource
  end

  private

  def check_out_existed_check_ins(entity)
    return unless entity.user_schedule
    past_check_ins = entity.user_schedule.check_ins.where(status: '1')
    past_check_ins.find_each { |check_in| check_in.update_attributes(status: '2') }
  end

  def validate_user_schedule_existance(entity)
    user_schedule = UserSchedule.where(id: entity.user_schedule_id).first
    if user_schedule
      entity.user_id ||= user_schedule.user_id
    else
      entity.errors.add(:user_schedule_id, :not_exist)
    end
  end

  def validate_user_check_in_existance(entity)
    if entity.user_schedule.check_ins.where(status: '1').present?
      entity.errors.add(:created_at, :already_checked_in)
    end
  end

  def validate_user_check_out_existance(entity)
    if entity.user_schedule.check_ins.where(status: '2').present?
      entity.errors.add(:created_at, :already_checked_out)
    end
  end

  def validate_check_in_date(entity)
    if entity.user_schedule && day = entity.user_schedule.try(:department_block).try(:day)
      entity.errors.add(:created_at, :not_assigned) if day.to_date != Time.current.to_date
    end
  end

  def validate_dates(entity)
    if entity.check_out_time && (entity.created_at_changed? || entity.check_out_time_changed?) && entity.created_at > entity.check_out_time
      entity.errors.add(:created_at, :less_than_check_out)
    end
  end

  def filter_attributes(attrs)
    attrs.keep_if { |k,v| @options[:accessible_attributes].include?(k.to_s) }
  end

  def format_dates(attrs)
    attrs[:created_at] = DateTime.strptime(attrs[:created_at], "%m/%d/%Y %I:%M %p").strftime("%Y-%m-%d %H:%M:%S") if attrs[:created_at].present?
    attrs[:check_out_time] = DateTime.strptime(attrs[:check_out_time], "%m/%d/%Y %I:%M %p").strftime("%Y-%m-%d %H:%M:%S") if attrs[:check_out_time].present?
    attrs
  end
end