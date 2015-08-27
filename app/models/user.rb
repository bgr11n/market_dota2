class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :uid, type: String
  field :steam_id, type: String
  field :nickname, type: String
  field :name, type: String
  field :image, type: String
  field :profile_url, type: String
  field :balance, type: Integer, default: 0

  has_many :listings, inverse_of: :user
  has_many :bought, class_name: 'Listing', inverse_of: :bought_by

  validates_numericality_of :balance, greater_than_or_equal_to: 0, message: "Не достаточно денег на счету."
end
