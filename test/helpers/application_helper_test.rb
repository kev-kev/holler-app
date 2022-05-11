require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "rails sample app"
    assert_equal full_title('help'), "help | rails sample app"
  end
end