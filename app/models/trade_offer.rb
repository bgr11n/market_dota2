class TradeOffer
  include Mongoid::Document
  include Mongoid::Timestamps
  field :sid, type: String
  field :goal, type: Integer
  field :status, type: String, default: 'awaits'
  field :desc, type: String, default: ''

  RECEIVE, GIVE = [100, 200]

  belongs_to :bot
  belongs_to :listing

  validates :goal, inclusion: { in: [100, 200] }
  validates :status, inclusion: { in: ['awaits', 'finished', 'failed'] }

  def description
    case desc
    when 'k_ETradeOfferStateInvalid' then 'Invalid'
    when 'k_ETradeOfferStateActive' then 'This trade offer has been sent, neither party has acted on it yet'
    when 'k_ETradeOfferStateAccepted' then 'The trade offer was accepted by the recipient and items were exchanged'
    when 'k_ETradeOfferStateCountered' then 'The recipient made a counter offer'
    when 'k_ETradeOfferStateExpired' then 'The trade offer was not accepted before the expiration date'
    when 'k_ETradeOfferStateCanceled' then 'The sender cancelled the offer'
    when 'k_ETradeOfferStateDeclined' then 'The recipient declined the offer'
    when 'k_ETradeOfferStateInvalidItems' then 'Some of the items in the offer are no longer available (indicated by the missing flag in the output)'
    when 'k_ETradeOfferStateEmailPending' then 'The offer hasnt been sent yet and is awaiting email confirmation'
    when 'k_ETradeOfferStateEmailCanceled' then 'The receiver cancelled the offer via email'
    when 'MarketTimeExpired' then 'The receiver cancelled the offer via email'
    end
  end

  def receive?
    goal == RECEIVE
  end

  def give?
    goal == GIVE
  end
end
