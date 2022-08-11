require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "holler"
    assert_equal full_title('contact'), "contact | holler"
  end
end