require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user1)
  end

  def check_basic_links
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path 
  end

  test "layout links when signed out" do
    get root_path
    check_basic_links
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
  end

  test "layout links when signed in" do
    log_in_as(@user) 
    follow_redirect!
    check_basic_links
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
  end

  test "page titles and templates when signed out" do
    get root_path
    assert_select "title", "rails sample app"
    assert_template 'static_pages/home'

    get contact_path
    assert_select "title", full_title("contact")
    assert_template 'static_pages/contact'

    get help_path
    assert_select "title", full_title("help")
    assert_template 'static_pages/help'

    get signup_path
    assert_select "title", full_title("sign up")
    assert_template 'users/new'

    get login_path
    assert_select "title", full_title("log in")
    assert_template 'sessions/new'
  end

  test "page titles and templates when signed in" do
    log_in_as(@user)
    get users_path
    assert_select "title", full_title("all users")
    assert_template "users/index"

    get user_path(@user)
    assert_select "title", full_title(@user.name)
    assert_template "users/show"

    get edit_user_path(@user)
    assert_select "title", full_title("edit user")
    assert_template "users/edit"
  end
end
