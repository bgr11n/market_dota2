module UsersHelper
  def current_user
    @current_user ||= User.find_by uid: session[:uid] if session[:uid].present?
  end

  def signed_in?
    !! current_user
  end
end
