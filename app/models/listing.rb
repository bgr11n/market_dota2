class Listing
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: Integer
  field :price, type: Integer
  field :buy_price, type: Integer

  AWAITS, ACTIVE, PENDING, SOLD = [0, 100, 200, 300]

  belongs_to :item, touch: true
  belongs_to :user, inverse_of: :listings
  belongs_to :bought_by, class_name: 'User', inverse_of: :bought

  validates :item, presence: { message: 'не может быть пустым.' }
  validates :user, presence: { message: 'не может быть пустым.' }
  validates_numericality_of :price, greater_than: 0, message: 'Цена должна быть больше 0.'
  validates_numericality_of :buy_price, greater_than: 0, message: 'Цена покупки должна быть больше 0.'
  validate :user_cant_buy_own_item
  validates :status, inclusion: { in: [0, 100, 200, 300], message: "%{value} не верный статус." }

  scope :active, -> { where(status: Listing::ACTIVE) }
  scope :by, ->(user) { user ? where(user_id: user.id) : all }
  default_scope -> { where(status: Listing::ACTIVE).order(buy_price: :asc) }

  after_save :update_item

  def as_json
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
      self.status = SOLD
      user.balance += self.price
      self.save and user.save and buyer.save
      { success: true }
    else
      errors = self.errors.messages.values.flatten
      errors += buyer.errors.messages.values.flatten
      { success: false, errors: errors }
    end
  end

  private

  def update_item
    self.item.fetch_min_buy_price
  end

  def user_cant_buy_own_item
    if user_id == bought_by_id
      errors.add(:bought_by_id, "Вы не можете купить свою вещь.")
    end
  end
end
