require 'httparty'

module Steam
  class TradeOffer
    include HTTParty
    base_uri Settings[:steam][:api_url]

    class << self
      def status trade_offer_id, api_key
        get "/IEconService/GetTradeOffer/v1", query: { key: api_key, tradeofferid: trade_offer_id }
      end

      def cancel trade_offer_id, api_key
        post "/IEconService/CancelTradeOffer/v1", query: { key: api_key, tradeofferid: trade_offer_id }
      end
    end
  end
end
