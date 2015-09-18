class ApplicationController < ActionController::Base
  include UsersHelper

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def authenticate
    redirect_to :root, :flash => { :error => "Необходимо авторизироваться" } unless signed_in?
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def check_tradability
    # TODO: придумать логику проверки
    # TODO: впилить ссылку на проверку
    redirect_to :back, :flash => { :error => "Вам необходимо пройти проверку доступности обменов" } unless current_user.tradable
  end
end
