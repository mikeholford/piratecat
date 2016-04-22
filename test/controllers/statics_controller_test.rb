require 'test_helper'

class StaticsControllerTest < ActionController::TestCase
  test "should get landing" do
    get :landing
    assert_response :success
  end

  test "should get webhooks" do
    get :webhooks
    assert_response :success
  end

end
