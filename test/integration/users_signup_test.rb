require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "signing up with invalid info" do
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
    assert_select 'form ul li', 3
  end
 end
