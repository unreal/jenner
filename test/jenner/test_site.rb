require 'helper'

class TestSite < Test::Unit::TestCase
  def test_array_of_items
    assert_equal Array, @site.items.class
    assert @site.items.size > 0
  end
end
