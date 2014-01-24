require 'helper'

class TestItem < Test::Unit::TestCase
  def test_initialize_with_yaml_header_initializes_required_options
    item = Jenner::Item.new("---\ntitle: 'test'\ndate: 2014-01-23 17:02:00 -6\ntemplate: 'test'\n---", @site)
    assert_equal "test", item.title
    assert_equal Time.new(2014,1,23,17,2,0,"-06:00"), item.date
    assert_equal "test", item.template_name
  end

  def test_from_file
    item = Jenner::Item.from_file(site_file("test.html"),@site)
    assert_equal "test", item.title
    assert_equal Time.new(2014,1,23,17,2,0,"-06:00"), item.date
    assert_equal "wrapper", item.template_name
  end

  def test_template_is_a_jenner_template
    item = Jenner::Item.from_file(site_file("test.html"),@site)
    assert_equal Jenner::Template, item.template.class
  end

  def test_render
    item = Jenner::Item.from_file(site_file("test.html"),@site)
    assert_equal "top\ntest\n2014-01-23 17:02:00 -0600\nwrapper\ntest\nitem content\n\nbottom\n", item.render
  end
end
