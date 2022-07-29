require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:test_user1)
    @micropost = Micropost.new(content: "hihi", user_id: @user.id)
  end 
  
  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = ""
    assert_not @micropost.valid?
  end

  test "content should be 140 chars max" do
    @micropost.content = "hi" * 71
    assert_not @micropost.valid?
  end
end
