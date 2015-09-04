class ItemsController < ApplicationController
  before_action :authenticate, only: [:create]
  before_action :parse_json_item, only: [:create]
  before_action :fetch_data, only: [:create]

  def index
    @items = Item.includes(:listings).all.select { |i| i.listings.size > 0 }
  end

  def create
    redirect_to(:back) and return if @listing.save && @item.save
    errors = @item.errors.full_messages.flatten
    errors += @listing.errors.full_messages.flatten
    redirect_to inventory_path, :flash => { :error => errors.join("<br>") }
  end

  def show
    @item = Item.includes(:listings).find_by(market_hash_name: params[:market_hash_name]) or not_found
  end

  private

  def fetch_data
    @item = fetch_item @data
    @listing = fetch_listing @data
    @listing.item = @item
  end

  def fetch_item data
    item = Item.find_or_create_by item_id: data['item_id'], classid: data['classid']
    item.name = data['name']
    item.market_hash_name = data['market_hash_name']
    item.market_name = data['market_name']
    item.name_color = data['name_color']
    item.descriptions = [data['descriptions']].flatten
    item.type = data['type']
    item.icon_url = data['icon_url']
    item.tags = data['tags']
    item.human_tags = data['human_tags']
    item.steam_price_info = data['steam_price_info']
    item
  end

  def fetch_listing data
    Listing.new price: (data['price'].to_f * 100),
                buy_price: (data['buy_price'].to_f * 100),
                user_id: current_user.id,
                status: Listing::ACTIVE
  end

  def parse_json_item
    @data = JSON.parse(params[:json_item])
  end
end
