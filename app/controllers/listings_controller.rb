class ListingsController < ApplicationController
  before_action :authenticate
  before_action :load_listing

  def show
    render json: { listing: @listing.as_json, item: @listing.item }
  end

  def update
    price = listing_params[:price].to_f * 100
    buy_price = listing_params[:buy_price].to_f * 100
    @listing.assign_attributes price: price, buy_price: buy_price
    if @listing.save
      redirect_to :back, :flash => { :notice => 'Изменения сохранены' }
    else
      redirect_to :back, :flash => { :error => @listing.errors.full_messages }
    end
  end

  def destroy
    @listing.delete
    redirect_to :root, :flash => { :notice => 'Лот удален.' }
  end

  def buy
    status = @listing.sell_to current_user
    redirect_to(:back, :flash => { :notice => "Поздравляем с успешной покупкой" }) and return if status[:success]
    redirect_to :back, :flash => { :error => status[:errors].join("<br>") }
  end

  private

  def load_listing
    @listing = Listing.includes(:item).find(params[:id]) or not_found
  end

  def listing_params
    params.require(:listing).permit(:price, :buy_price)
  end
end
