require "test_helper"

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user2)
    log_in_as(@user)
    @other_user = users(:test_user4)
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

  test "should follow a user with html" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other_user.id }
    end
  end

  test "should follow a user with ajax" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other_user.id }
      # xhr: true
    end
  end

  test "should unfollow a user with html" do
    @user.follow(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with ajax" do
    @user.follow(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
