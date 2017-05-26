FactoryGirl.define do
  factory :donation do
    donator
    description { Faker::Lorem.sentence }
    pickup_time_from { Time.zone.now + rand(1..7200).seconds }
    pickup_time_to { pickup_time_from + rand(1..7200).seconds }
    address do
      ['Lavalleja 152, CABA', 'Güemes 4673, CABA', 'Lavardén 389, CABA', 'Paraguay 4229, CABA',
       '100 Spear st, San Francisco, CA', '115 Main St, San Francisco, CA'].sample
    end
  end
end
