require "test_helper"

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user1)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert @user.following.any?
    assert_select "#following", @user.following.count.to_s
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert @user.following.any?
    assert_select "#followers", @user.followers.count.to_s
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end
