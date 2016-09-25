FactoryGirl.define do
  factory :donation do
    donator
    description { Faker::Lorem.sentence }
    pickup_time_from { Time.zone.now + rand(1..7200).seconds }
    pickup_time_to { pickup_time_from + rand(1..7200).seconds }
  end
end
