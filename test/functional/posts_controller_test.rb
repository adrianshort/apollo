require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  test "should get near" do
    get :near
    assert_response :success
  end

end
