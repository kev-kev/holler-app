require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user1)
    @other_user = users(:test_user2)
  end

  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", "sign up | rails sample app"
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert flash.any?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { 
      user: { 
        name: @user.name,
        email: @user.email,
      }
    }
    assert flash.any?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as other user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as other user" do
    log_in_as(@other_user)
    patch user_path(@user), params: {
      user: { 
        name: @user.name,
        email: @user.email,
      }
    }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_path
  end
end
