require 'helper'

class TestTag < Test::Unit::TestCase
  def setup
    super

    @tag = Jenner::Tag.new('one', @site)
  end

  def test_name
    assert_equal "one", @tag.name
  end

  def test_items
    assert_equal "/test.html", @tag.items.first.url
  end

  def test_to_liquid
    assert_equal "one", @tag.to_liquid["name"]
    assert_equal "/test.html", @tag.to_liquid["items"].first.url
  end
end
