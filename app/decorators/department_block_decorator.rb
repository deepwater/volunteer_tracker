class DepartmentBlockDecorator < Draper::Decorator
  delegate_all

  def name_with_date_and_period
    "#{name} | #{day.short_date} | #{start_time} - #{end_time}"
  end
end