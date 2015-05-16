FactoryGirl.define do
  factory :day do
    mday Time.now.mday 
    month Time.now.month
    year Time.now.year
    day_type  %w(1 2 3).sample
    event
    date Time.now
  end
end
