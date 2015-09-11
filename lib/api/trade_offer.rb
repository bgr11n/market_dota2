require 'httparty'

module Api
  class TradeOffer
    include HTTParty
    base_uri Rails.application.config.api['url']

    class << self
      def make data
        res = post "/offers/make", body: trade_offer_body(data).to_json,
                                   headers: headers
        puts res.to_json
      end

      private

      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def trade_offer_body data
        body = {}
        body[:partner_steam_id] = data[:partner_steam_id]
        body[:item_from_bot] = item data[:item_id_to_give] if data[:item_id_to_give]
        body[:item_from_them] = item data[:item_id_to_recieve] if data[:item_id_to_recieve]
        body[:message] = data[:message]
        body
      end

      def item item_id
        {
          appid: 570,
          contextid: 2,
          amount: 1,
          assetid: item_id
        }
      end
    end
  end
end
