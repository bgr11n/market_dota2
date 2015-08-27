class InventoryController < ApplicationController
  before_action :authenticate, only: [:index]

  def index
    res = HTTParty.get(current_user.profile_url + "/inventory/json/570/2?l=russian")
    render 'errors/hidden_profile' and return unless res['success']

    @items = res['rgInventory'].map do |k, v|

      tradable = res['rgDescriptions']["#{v['classid']}_#{v['instanceid']}"]['tradable']
      data = res['rgDescriptions']["#{v['classid']}_#{v['instanceid']}"]
      {
        item_id: v['id'],
        classid: v['classid'],
        name: data['name'],
        market_hash_name: data['market_hash_name'],
        market_name: data['market_name'],
        name_color: data['name_color'],
        descriptions: data['descriptions'],
        type: data['type'],
        icon_url: 'https://steamcommunity-a.akamaihd.net/economy/image/' + data['icon_url'],
        tags: data['tags']
      } if tradable == 1

    end.compact!
    render 'errors/no_tradable_item' and return if @items.empty?
  end

  def item_price
    res = HTTParty.get("#{Settings[:steam][:price_url]}?appid=570&currency=#{Settings[:app][:currency][:steam_code]}&market_hash_name=#{params[:market_hash_name]}")
    render json: res.to_json
  end
end
