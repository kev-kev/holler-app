require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "invalid login" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert flash.any?
    get root_path
    assert flash.empty?
  end

  test "valid login" do
  end
end