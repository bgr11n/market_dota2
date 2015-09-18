class Listing
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: Integer
  field :price, type: Integer
  field :buy_price, type: Integer
  field :await_to, type: DateTime
  field :guarantee_to, type: DateTime

  AWAITS, ACTIVE, SOLD, STORED, FAILED = [0, 100, 200, 300, 400]

  belongs_to :item, touch: true
  belongs_to :user, inverse_of: :listings
  belongs_to :bought_by, class_name: 'User', inverse_of: :bought
  has_many :trade_offers

  validates :item, presence: true
  validates :user, presence: true
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :buy_price, greater_than: 0
  validates_numericality_of :buy_price, greater_than: :price
  validates :status, inclusion: { in: [0, 100, 200, 300] }
  validate :user_cant_buy_own_item

  scope :active, -> { where(status: Listing::ACTIVE) }
  scope :by, ->(user) { user ? where(user_id: user.id) : all }
  scope :bought, ->(user) { user ? where(bought_by_id: user.id) : all }
  default_scope -> { order(buy_price: :asc) }

  after_save :update_item

  def as_json options = {}
    {
      id: id.to_s,
      status: status,
      user_id: user_id,
      price: price,
      buy_price: buy_price,
      item_id: item_id.to_s,
      bought_by_id: bought_by_id
    }
  end

  def sell_to buyer
    buyer.balance -= self.buy_price
    self.bought_by_id = buyer.id
    if self.valid? && buyer.valid?
      self.status = AWAITS
      self.await_to = DateTime.now + 1.hour
      CheckForReceivedItemWorker.perform_in(1.hour, self.id)
      user.balance += self.price
      self.save and user.save and buyer.save
      { success: true }
    else
      errors = self.errors.full_messages
      errors += buyer.errors.full_messages
      { success: false, errors: errors }
    end
  end

  private

  def update_item
    self.item.fetch_min_buy_price
  end

  def user_cant_buy_own_item
    errors.add(:bought_by, "^Вы не можете купить свою вещь") if user_id == bought_by_id
  end
end
