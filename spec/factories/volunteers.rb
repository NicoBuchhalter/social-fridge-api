FactoryGirl.define do
  factory :volunteer do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    username { Faker::Internet.user_name }
    fb_id { Faker::Internet.password(8) }
    fb_access_token { Faker::Internet.password(12) }
  end
end
