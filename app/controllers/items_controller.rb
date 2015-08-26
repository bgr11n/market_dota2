class ItemsController < ApplicationController
  before_action :authenticate, only: [:buy_listing, :create]
  before_action :load_listing, only: [:buy_listing]
  # before_action :check_user, only: [:buy_listing]
  before_action :buy_user_balance, only: [:buy_listing]
  before_action :sell_user_balance, only: [:buy_listing]
  before_action :parse_json_item, only: [:create]

  def index
    @items = Item.includes(:listings).all.select { |i| i.listings.size > 0 }
  end

  def create
    item = fetch_item @data
    listing = fetch_listing @data
    item.listings << listing
    # TODO: if some errors
    if item.save && listing.save
      redirect_to :root
    end
  end

  def show
    @item = Item.includes(:listings).find_by(market_hash_name: params[:market_hash_name]) or not_found
  end

  def buy_listing
    @listing.update status: Listing::SOLD, bought_by_id: current_user.id
    redirect_to :root, :flash => { :notice => "Поздравляем с успешной покупкой." }
  end

  private

  def load_listing
    @listing = Listing.find(params[:id])
  end

  def buy_user_balance
    balance = current_user.balance - @listing.buy_price.to_f * 100
    if balance < 0
      redirect_to item_path(@listing.item.market_hash_name), :flash => { :notice => "Не достаточно денег на счету." }
    else
      current_user.balance = balance
      current_user.save
    end
  end

  def sell_user_balance
    user = @listing.user
    user.balance = user.balance + @listing.price.to_f * 100
    user.save
  end

  def check_user
    redirect_to item_path(@listing.item[:market_hash_name]), :flash => { :notice => "Вы не можете купить свою вещь." } if @listing.user_id == current_user.id
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
    Listing.new price: data['price'],
                buy_price: data['buy_price'],
                user_id: current_user.id,
                status: Listing::ACTIVE
  end

  def parse_json_item
    @data = JSON.parse(params[:json_item])
  end
end
