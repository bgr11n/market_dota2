class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :uid, type: String
  field :steam_id, type: String
  field :nickname, type: String
  field :name, type: String
  field :image, type: String
  field :profile_url, type: String
end
