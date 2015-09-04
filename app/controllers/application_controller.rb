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
end
