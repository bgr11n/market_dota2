class Bot
  include Mongoid::Document
  include Mongoid::Timestamps
  field :login, type: String
  field :password, type: String
  field :api_key, type: String

  has_many :trade_offers
end
