class FastCheckService
  attr_reader :errors, :resource

  def initialize(options = {})
    @errors = []
    @accessor = options[:as]
    @resource = CheckIn.new
  end

  def in(params)
    schedule = UserSchedule.find(param[:user_schedule_id]) rescue nil
    if schedule
      @resource = schedule.check_ins.new status: "1", user_id: @accessor.id
      @resource.save
    else
      @errors << "Wrong User Schedule ID! Please Retry."
    end
    resource
  end

  def out(params)
    schedule = UserSchedule.find(param[:user_schedule_id]) rescue nil
    if schedule
      check_in = schedule.check_ins.last
    else
      @errors << "Wrong User Schedule ID! Please Retry."
    end
  end
end