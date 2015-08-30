class ListingsController < ApplicationController
  before_action :authenticate
  before_action :load_listing

  def show
    listing = Listing.find(params[:id])
    render json: { listing: listing, item: listing.item }
  end

  def edit
    @item = @listing.item
  end

  def buy
    status = @listing.sell_to current_user
    redirect_to(:root, :flash => { :notice => "Поздравляем с успешной покупкой." }) and return if status[:success]
    redirect_to item_path(@listing.item.market_hash_name), :flash => { :notice => status[:errors].join("<br>") }
  end

  private

  def load_listing
    @listing = Listing.includes(:item).find(params[:id])
  end
end
