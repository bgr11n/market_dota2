class Listing
  include Mongoid::Document
  include Mongoid::Timestamps
  field :price, type: String
  field :buy_price, type: String

  belongs_to :item
  belongs_to :user

  before_save :format_price

  private

  def format_price
    self.price = '%.2f' % self.price
    self.buy_price = '%.2f' % self.buy_price
  end
end
