require 'pry'
require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user1)
  end
  
  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    # invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert flash.any?
    assert_template 'password_resets/new'
    # valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert flash.any?
    assert_redirected_to root_path
    # pw reset form
    user = assigns(:user)
    # wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_path
    # inactive email
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_path
    user.toggle!(:activated)
    # invalid token
    get edit_password_reset_path("bad token", email: user.email)
    # valid email and token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # pw and confirmation mismatch
    patch password_reset_path(user.reset_token), 
      params: {
        email: user.email,
        user: {
          password: "asdfasdf",
          password_confirmation: "qwerqwer"
        }
      }
    assert_select 'div#error_explanation'
    # empty pw fields
    patch password_reset_path(user.reset_token),
      params: {
        email: user.email,
        user: {
          password: "",
          password_confirmation: ""
       }
      }
    assert_select 'div#error_explanation'
    # valid pw and confirmation
    patch password_reset_path(user.reset_token),
      params: {
        email: user.email,
        user: {
          password: "123123",
          password_confirmation: "123123"
        }
      }
    assert is_logged_in?
    assert flash.any?
    assert_redirected_to user
    assert_nil user.reload.reset_digest
    assert_nil user.sent_at
  end

  test "expired reset token" do
    get new_password_reset_path
    post password_resets_path, params: {
      password_reset: { email: @user.email } 
    }
    @user = assigns(:user)
    @user.update_attribute(:sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
      params: { 
        email: @user.email,
        user: {
          password: "123123",
          password_confirmation: "123123"
        }
      }
    assert_response :redirect
    follow_redirect!
    assert_match 'expired', response.body
  end
end
