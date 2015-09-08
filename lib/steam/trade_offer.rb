module Steam
  class TradeOffer
    def self.make
      query = {
                'sessionid' => '6df90b1ade2cb39023b4c644',
                'serverid' => 1,
                'partner' => 76561198074242150,
                'json_tradeoffer' => { 'newversion' => true, 'version' => 2, 'me' => { 'assets' => [{ 'appid' => 570, 'contextid' => 2, 'amount' => 1, 'assetid' => 1132812201 }], 'currency' => [], 'ready' => false }, 'them' => { 'assets' => [], 'currency' => [], 'ready' => false }}.to_json
              }
      headers = { 'referer' => 'https://steamcommunity.com/tradeoffer/new/?partner=113976422' }
      res = HTTParty.post('https://steamcommunity.com/tradeoffer/new/send', query: query, headers: headers)
      puts '================================'
      puts res.to_json
      puts '================================'
    end
  end
end
