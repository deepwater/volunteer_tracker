FactoryGirl.define do
  factory :event do
    name 'Gilroy Garlic Festival'
    route_type %w(1 2 3).sample
    day_of_start Time.now - 1.day
    day_of_finish Time.now + 1.day
    organisation
  end
end
