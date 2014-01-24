require 'helper'

class TestItem < Test::Unit::TestCase
  def test_initialize
    item = Jenner::Item.new('test.html',@site)
    assert_equal "test", item.title
    assert_equal Time.new(2014,1,23,17,2,0,"-06:00"), item.date
    assert_equal "wrapper", item.template_name
  end

  def test_template_is_a_jenner_template
    item = Jenner::Item.new('test.html',@site)
    assert_equal Jenner::Template, item.template.class
  end

  def test_render
    item = Jenner::Item.new('test.html',@site)
    assert_equal "top\ntest\n2014-01-23 17:02:00 -0600\nwrapper\ntest\nitem content\n\nbottom\n", item.render
  end

  def test_public_path
    item = Jenner::Item.new('test.html',@site)
    assert_equal site_file('public/test.html'), item.public_path
  end

  def test_generate
    item = Jenner::Item.new('test.html',@site)
    item.generate!
    assert File.exists?(site_file('public/test.html'))
    assert_equal item.render, File.read(site_file('public/test.html'), encoding: "US-ASCII")
  end
end
