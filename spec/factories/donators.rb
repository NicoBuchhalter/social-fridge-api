FactoryGirl.define do
  factory :donator do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    name { Faker::Company.name }
    address do
      ['Lavalleja 152, CABA', 'Güemes 4673, CABA', 'Lavardén 389, CABA', 'Paraguay 4229, CABA',
       '100 Spear st, San Francisco, CA', '115 Main St, San Francisco, CA'].sample
    end
  end
end
