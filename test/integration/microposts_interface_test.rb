require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user1)
  end
  # log in, check the micropost pag- ination, make an invalid submission, make a valid submission, delete a post, and then visit a second user’s page to make sure there are no “delete” links. 
  test "microposts interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input', type: 'file' 
    # invalid post
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2' # correct link, rather than /microposts/...
    # valid post
    image = fixture_file_upload('test/fixtures/cool_dog.jpg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: 
        { content: "hihi", image: image } 
      }
    end
    assert @user.microposts.first.image.attached?
    assert_redirected_to root_path
    follow_redirect!
    assert_match 'hihi', response.body
    #delete post
    assert_select 'a', text: 'delete'
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(microposts(:beans))
    end
    get user_path(users(:test_user2))
    assert_select 'a', text: 'delete', count: 0
  end

  test "microposts sidebar count" do
    log_in_as(@user)
    get root_path
    assert_select 'span', text: "#{@user.microposts.count} microposts"
    other_user = users(:test_user2)
    log_in_as(other_user)
    get root_path
    assert_select 'span', text: "0 microposts"
    other_user.microposts.create(content: "first!")
    get root_path
    assert_select 'span', text: "1 micropost"
  end

end
