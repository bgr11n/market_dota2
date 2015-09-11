require 'httparty'

module Steam
  class TradeOffer
    include HTTParty
    base_uri Settings[:steam][:api_url]

    class << self
      def status trade_offer_id
        res = get "/IEconService/GetTradeOffer/v1", query: { key: Settings[:steam][:api_key], tradeofferid: trade_offer_id }
        puts res.to_json
      end
    end
  end
end
