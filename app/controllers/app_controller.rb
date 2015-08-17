class AppController < ApplicationController
  before_action :load_user, only: :auth_callback

  def index
  end

  def auth_callback
    session[:uid] = @auth['uid']
    redirect_to :root
  end

  def logout
    reset_session
    redirect_to :back
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
