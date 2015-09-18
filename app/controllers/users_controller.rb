class UsersController < ApplicationController
  before_action :load_user, only: :auth_callback
  before_action :authenticate, only: [:account, :logout]

  def account
    @sold_listings = Listing.unscoped.includes(:item)
                            .any_of( { user_id: current_user.id }, { bought_by_id: current_user.id } )
                            .where( status: Listing::SOLD )
                            .order(updated_at: :desc)
    @active_listings = Listing.includes(:item).order(updated_at: :desc).active.by current_user
    @listings_to_pass = Listing.includes(:item).where(status: Listing::AWAITS).by current_user
    @listings_to_receive = Listing.includes(:item).where(:status.in => [Listing::STORED, Listing::AWAITS]).bought current_user
  end

  def auth_callback
    session[:uid] = @auth['uid']
    redirect_to :root
  end

  def logout
    reset_session
    redirect_to :root
  end

  private

  def load_user
    @auth = request.env['omniauth.auth']
    user = User.find_or_create_by steam_id: @auth['extra']['raw_info']['steamid'], uid: @auth['uid']
    user.nickname = @auth['info']['nickname']
    user.name = @auth['info']['name']
    user.image = @auth['info']['image']
    user.profile_url = @auth['info']['urls']['Profile']
    user.save
  end
end
