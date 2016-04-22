require 'test_helper'

class BotControllerTest < ActionController::TestCase
  test "should get webhook" do
    get :webhook
    assert_response :success
  end

end
