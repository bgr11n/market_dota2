module ListingHelper
  def created_by_current_user id
    signed_in? ? id == current_user.id : false
  end
end
