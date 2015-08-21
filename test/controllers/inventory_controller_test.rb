require 'test_helper'

class InventoryControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get item_price" do
    get :item_price
    assert_response :success
  end

end
