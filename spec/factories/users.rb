require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.uid { Faker::Code.ean }
    f.steam_id { Faker::Code.ean }
    f.nickname { Faker::Internet.user_name }
    f.name { Faker::Name.name }
    f.image { Faker::Avatar.image }
    f.profile_url { Faker::Internet.url }
    f.balance { Faker::Number.between(100, 300) }
  end
end
