class SendItemWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform sid, created_at, api_key
    res = Steam::TradeOffer.status sid, api_key
    if offer_accepted(res)
      trade_offer = TradeOffer.includes(:listing).find_by sid: sid
      listing = trade_offer.listing
      trade_offer.update status: 'finished', desc: status(res['response']['offer']['trade_offer_state'])
      listing.update status: Listing::SOLD
    elsif offer_active(res)
      ReceiveItemWorker.perform_in(50.seconds, sid, created_at, api_key)
    elsif offer_not_accepted(res) || (Time.now - created_at.to_time) > 60 * 60 * 4
      trade_offer = TradeOffer.includes(:listing).find_by sid: sid
      listing = trade_offer.listing
      trade_offer.update status: 'failed', desc: status(res['response']['offer']['trade_offer_state'])
      listing.update status: Listing::STORED
      Steam::TradeOffer.cancel sid, api_key
    end
  end

  private

  def offer_active data
    data['response']['offer']['trade_offer_state'] == 2
  end

  def offer_accepted data
    data['response']['offer']['trade_offer_state'] == 3
  end

  def offer_not_accepted data
    ! offer_accepted(data)
  end

  def status code
    case code
    when 1 then 'k_ETradeOfferStateInvalid'
    when 2 then 'k_ETradeOfferStateActive'
    when 3 then 'k_ETradeOfferStateAccepted'
    when 4 then 'k_ETradeOfferStateCountered'
    when 5 then 'k_ETradeOfferStateExpired'
    when 6 then 'k_ETradeOfferStateCanceled'
    when 7 then 'k_ETradeOfferStateDeclined'
    when 8 then 'k_ETradeOfferStateInvalidItems'
    when 9 then 'k_ETradeOfferStateEmailPending'
    when 10 then 'k_ETradeOfferStateEmailCanceled'
    end
  end
end
