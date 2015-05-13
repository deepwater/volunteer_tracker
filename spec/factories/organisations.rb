FactoryGirl.define do
  factory :organisation do
    name 'Some organization'
    sequence(:subdomain) { |n| "subdomain#{n}" }
  end
end
