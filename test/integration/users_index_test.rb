require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user1)
    @other_user = users(:test_user2)
  end
  
  test "index as admin, including pagination and deleting" do
    log_in_as(@user)
    first_page = User.paginate(page: 1)
    first_page.first.toggle!(:activated)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination", count: 2
    assigns(:users).each do |user|
      assert user.activated?
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @user
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
  end

  test "index as non-admin" do
    log_in_as(@other_user)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
