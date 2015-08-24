class InventoryController < ApplicationController
  before_action :authenticate, only: [:index]

  def index
    hash = HTTParty.get(current_user.profile_url + "/inventory/json/570/2?l=russian")

    # TODO: Handle error like this:
    # {"success"=>false, "Error"=>"Этот профиль скрыт."}

    @items = hash['rgInventory'].map do |k, v|

      tradable = hash['rgDescriptions']["#{v['classid']}_#{v['instanceid']}"]['tradable']
      data = hash['rgDescriptions']["#{v['classid']}_#{v['instanceid']}"]
      {
        item_id: v['id'],
        classid: v['classid'],
        name: data['name'],
        market_hash_name: data['market_hash_name'],
        name_color: data['name_color'],
        descriptions: data['descriptions'],
        type: data['type'],
        icon_url: 'https://steamcommunity-a.akamaihd.net/economy/image/' + data['icon_url'],
        tags: data['tags']
      } if tradable == 1

    end.compact!
  end

  def item_price
    res = HTTParty.get("#{Settings[:steam][:price_url]}?appid=570&currency=1&market_hash_name=#{params[:market_hash_name]}")
    render json: res.to_json
  end
end
