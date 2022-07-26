require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "aaa",
          password_confirmation: "123",
        }
      }
    end
    assert_template "users/new"
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    assert_select 'form ul li', 4
  end

  test "valid signup with account activation" do
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: "Jean Green",
          email: "meanjean@bean.cream",
          password: "abc123",
          password_confirmation: "abc123",
        }
      }
    end
    assert_equal ActionMailer::Base.deliveries.size, 1
    user = assigns(:user)
    assert_not user.activated?
    # login attempt before activation
    log_in_as(user)
    assert_not is_logged_in?
    # using invalid token
    get edit_account_activation_path("an invalid token", email: user.email)
    assert_not is_logged_in?
    # valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: "bad email")
    assert_not is_logged_in?
    # valid token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert flash.any?
  end
end