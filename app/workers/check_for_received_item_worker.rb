class CheckForReceivedItemWorker
  include Sidekiq::Worker

  def perform listing_id
    listing = Listing.find(listing_id)
    trade_offer = TradeOffer.where(listing_id: listing_id, goal: TradeOffer::RECEIVE, status: 'finished').first
    if trade_offer.nil?
      buyer = listing.bought_by
      buyer.balance += listing.buy_price
      listing.status = Listing::FAILED

      listing.save and buyer.save
    else
      seller = listing.user
      seller.balance += listing.price
      listing.status = Listing::STORED
      listing.guarantee_to = DateTime.now + 4.hours

      listing.save and buyer.save
    end
  end
end
