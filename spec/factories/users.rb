FactoryGirl.define do

  factory :user do
    email { FFaker::Internet.email }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    password 'password'

    trait :admin do
      after(:create){|user| user.add_role(Rhinoart::Role::SUPER_USER) }
    end
  end

end