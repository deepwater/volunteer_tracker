FactoryGirl.define do
  factory :user do
    organisation
    first_name 'John'
    last_name 'Doe'
    sequence(:email) { |n| "#{first_name}.#{last_name}#{n}@example.com" }
    sequence(:username) { |n| "#{first_name}_#{last_name}_#{n}" }
    password 'password'
    confirmed_at 1.hour.ago
  end

  factory :super_admin, parent: :user do
    role :super_admin
  end

  factory :volunteer, parent: :user do
    role :volunteer
  end

  factory :subaccount, parent: :volunteer do
    master
  end
end
