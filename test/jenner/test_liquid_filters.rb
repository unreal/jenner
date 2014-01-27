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

end
