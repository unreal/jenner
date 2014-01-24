require 'helper'

class TestSite < Test::Unit::TestCase
  def test_array_of_items
    assert_equal Array, @site.items.class
    assert @site.items.size > 0
  end

  def test_generate!
    @site.generate!
    assert File.exists?(site_file('public/test.html'))
  end
end
