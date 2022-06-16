require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
  end

  test "login with invalid email and password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert flash.any?
    get root_path
    assert flash.empty?
  end

  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { 
      session: { 
        email: @user.email, 
        password: ""
        }
      }
    assert_template "sessions/new"
    assert flash.any?
    get root_path
    assert flash.empty?
  end

  test "valid login" do
    get login_path
    post login_path, params: {
      session: {
        email: @user.email,
        password: 'password'
      }
    }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

end
