FactoryGirl.define do
  factory :day do
    name 'Some organization'
    sequence(:subdomain) { |n| "subdomain#{n}" }
  end
end
