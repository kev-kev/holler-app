require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        name: "",
        email: "invalid@email",
        password: "abc",
        password_confirmation: "123"
      }
    }
    assert_template 'users/edit'
    assert_select 'div.alert', "You have 4 errors to correct."
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    name = "joey jojo shabadoo"
    email = "xx_slayerxx_1@hotmail.ninja"
    patch user_path(@user), params: {
      user: {
        name: name,
        email: email,
        password: "",
        password_confirmation: "",
      }
    }
    assert flash.any?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
