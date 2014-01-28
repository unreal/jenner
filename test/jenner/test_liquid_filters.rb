require 'helper'

class TestLiquidFilters < Test::Unit::TestCase
  include Liquid

  def setup
    super

    @context = Liquid::Context.new({},{},site: @site)
    @context.add_filters(Jenner::LiquidFilters)
  end

  def test_item_from_path
    assert Variable.new("'test.html' | item_from_path").render(@context).is_a?(Jenner::Item)
  end

  def test_asset_from_path
    assert Variable.new("'foo.txt' | asset_from_path").render(@context).is_a?(Jenner::Asset)
  end

  def test_assign_to(value, name)
    assert_nil Variable.new("'bar' | assign_to: foo").render(@context)
    assert_equal "bar", @context['foo']
  end

  def test_stylesheet_tag
    assert_equal %(<link href="test.css" media="all" rel="stylesheet" type="text/css" />),
      Variable.new("'test.css' | stylesheet_tag").render(@context)
  end

  def test_javascript_tag
    assert_equal  %(<script type="text/javascript" src="test.js"></script>),
      Variable.new("'test.js' | javascript_tag").render(@context)
  end

  def test_link_to
    assert_equal %(<a href="/test.html">test</a>),
      Variable.new("'test.html' | item_from_path | link_to").render(@context)
  end

  def test_tag
    assert Variable.new("'one' | tag").render(@context).is_a?(Jenner::Tag)
  end

  def test_items_with_data
    items = Variable.new("'foo' | items_with_data").render(@context)
    paths = items.map(&:path)
    assert paths.include?("test.html")
    assert paths.include?("_hidden.html")
    assert paths.include?("markdown_test.markdown")
    assert !paths.include?("foo.txt")
  end

  def test_items_with_data_and_value
    items = Variable.new(%('foo' | items_with_data: "bar")).render(@context)
    paths = items.map(&:path)
    assert paths.include?("test.html")
    assert paths.include?("_hidden.html")
    assert !paths.include?("markdown_test.markdown")
  end

  def test_items_with_data_and_value_on_array
    items = Variable.new(%('bar' | items_with_data: 2)).render(@context)
    paths = items.map(&:path)
    assert !paths.include?("test.html")
    assert paths.include?("_hidden.html")
    assert paths.include?("markdown_test.markdown")
  end

end
