class ApplicationController < ActionController::Base
  include UsersHelper

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def authenticate
    redirect_to :root unless signed_in?
  end
end
