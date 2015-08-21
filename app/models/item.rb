class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  field :item_id, type: String
  field :classid, type: String
  field :name, type: String
  field :market_hash_name, type: String
  field :name_color, type: String
  field :descriptions, type: Array
  field :type, type: String
  field :icon_url, type: String
  field :tags, type: Array
  field :human_tags, type: String
  field :steam_price_info, type: Hash
  field :min_price, type: String

  has_many :listings

  before_save :fetch_min_price

  default_scope -> { order(:updated_at => :desc) }

  private

  def fetch_min_price
    self.min_price = listings.map(&:buy_price).sort.first
  end
end
