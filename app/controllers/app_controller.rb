class AppController < ApplicationController
  before_action :authenticate, only: [:load_inventory]

  def index
  end

  def load_inventory
    uri = URI(current_user.profile_url + "/inventory/json/570/2?l=russian")

    resp = Net::HTTP.get_response(uri)
    hash = JSON(resp.body)

    @items = hash['rgInventory'].map do |k, v|

      tradable = hash['rgDescriptions']["#{v['classid']}_#{v['instanceid']}"]['tradable']
      {
        item_id: v['id'],
        classid: v['classid'],
        title: hash['rgDescriptions']["#{v['classid']}_#{v['instanceid']}"]['market_hash_name'],
        icon_url: 'https://steamcommunity-a.akamaihd.net/economy/image/' +hash['rgDescriptions']["#{v['classid']}_#{v['instanceid']}"]['icon_url']
      } if tradable == 1

    end.compact!
    render 'inventory'
  end
end
