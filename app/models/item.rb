class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  field :item_id, type: String
  field :classid, type: String
  field :name, type: String
  field :market_hash_name, type: String
  field :market_name, type: String
  field :name_color, type: String
  field :descriptions, type: Array
  field :type, type: String
  field :icon_url, type: String
  field :tags, type: Array
  field :human_tags, type: String
  field :steam_price_info, type: Hash
  field :min_price, type: Integer, default: 0

  has_many :listings

  validates_numericality_of :min_price, greater_than_or_equal_to: 0

  default_scope -> { order(:updated_at => :desc) }

  def fetch_min_buy_price
    self.update min_price: self.listings.where(status: Listing::ACTIVE).map(&:buy_price).sort.first
  end
end
