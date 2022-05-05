require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "home | ruby on rails tutorial sample app"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "help | ruby on rails tutorial sample app"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "about | ruby on rails tutorial sample app"
  end
end
