class ItemsController < ApplicationController
  before_action :parse_json_item, only: [:create]

  def index
    @items = Item.all.select { |i| i.listings.size > 0 }
  end

  def create
    item = fetch_item @data
    listing = fetch_listing @data
    item.listings << listing
    if item.save && listing.save
      redirect_to :root
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  private

  def fetch_item data
    item = Item.find_or_create_by item_id: data['item_id'], classid: data['classid']
    item.name = data['name']
    item.market_hash_name = data['market_hash_name']
    item.name_color = data['name_color']
    item.descriptions = data['descriptions']
    item.type = data['type']
    item.icon_url = data['icon_url']
    item.tags = data['tags']
    item.human_tags = data['human_tags']
    item.steam_price_info = data['steam_price_info']
    item
  end

  def fetch_listing data
    Listing.new price: data['price'], buy_price: data['buy_price'], user_id: current_user.id
  end

  def parse_json_item
    @data = JSON.parse(params[:json_item])
  end
end
