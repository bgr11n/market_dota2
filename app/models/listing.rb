class Listing
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: Integer
  field :price, type: String
  field :buy_price, type: String

  belongs_to :item
  belongs_to :user, inverse_of: :listings
  belongs_to :bought_by, class_name: 'User', inverse_of: :bought

  before_save :format_price

  validates :status, inclusion: { in: [0, 100, 200, 300], message: "%{value} is not a valid status" }

  default_scope -> { where(status: Listing::ACTIVE).order(buy_price: :asc) }

  AWAITS, ACTIVE, PENDING, SOLD = [0, 100, 200, 300]

  private

  # TODO: Validate user not to his own item
  def user_cant_buy_own_item
    if status == SOLD && user_id == bought_by_id
      errors.add(:bought_by_id, "Вы не можете купить свою вещь.")
    end
  end

  def format_price
    self.price = '%.2f' % self.price
    self.buy_price = '%.2f' % self.buy_price
  end
end
