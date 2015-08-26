require 'faker'

FactoryGirl.define do
  factory :item do |f|
    f.item_id { Faker::Code.ean }
    f.classid { Faker::Code.ean }
    f.name { Faker::Company.name }
    f.market_hash_name { Faker::Company.name }
    f.market_name { Faker::Company.name }
    f.name_color '#D2D2D2'
    f.descriptions []
    f.type { Faker::Commerce.department }
    f.icon_url { Faker::Avatar.image }
    f.tags []
    f.human_tags Faker::Lorem.sentence
    f.steam_price_info {}
    f.min_price { Faker::Number.decimal(2) }
  end
end
