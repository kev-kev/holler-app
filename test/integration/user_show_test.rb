require "test_helper"

class UserShowTest < ActionDispatch::IntegrationTest
  def setup
    @inactive_user = users(:inactive_user)
    @active_user = users(:test_user1)
  end

  test "should redirect if user not activated" do
    get user_path(@inactive_user)
    assert_redirected_to root_url
  end

  test "should display if user is activated" do
    get user_path(@active_user)
    assert_template 'users/show'
  end
end
