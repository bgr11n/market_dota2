require 'faker'

FactoryGirl.define do
  factory :listing do |f|
    item
    user
    f.status 100
    f.price [1, 2, 3, 4, 5].sample
    f.buy_price [6, 7, 8, 9, 10].sample
    bought_by_id nil
  end
end
