require 'faker'

FactoryGirl.define do
  factory :listing do |f|
    item
    f.status 100
    f.price { Faker::Number.decimal(2) }
    f.buy_price { Faker::Number.decimal(2) }
  end
end
