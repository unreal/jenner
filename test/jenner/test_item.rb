# encoding: utf-8
require 'helper'

class TestItem < Test::Unit::TestCase
  def test_initialize
    item = Jenner::Item.new('test.html',@site)
    assert_equal "test", item.title
    assert_equal Time.new(2014,1,23,17,2,0,"-06:00"), item.date
    assert_equal "wrapper", item.template_name
    assert_equal({ "foo" => "bar" }, item.data)
  end

  def test_template_is_a_jenner_template
    item = Jenner::Item.new('test.html',@site)
    assert_equal Jenner::Template, item.template.class
  end

  def test_render
    item = Jenner::Item.new('test.html',@site)
    assert_equal "top\ntest\n2014-01-23 17:02:00 -0600\nwrapper\ntest\nbar\nitem content\n\nbottom\n", item.render
  end

  def test_public_path
    item = Jenner::Item.new('test.html',@site)
    assert_equal site_file('public/test.html'), item.public_path
  end

  def test_generate!
    item = Jenner::Item.new('test.html',@site)
    # make the public dir for the item, since @site normally does it
    FileUtils.mkdir(File.join(@site.root,'public'))
    item.generate!
    assert File.exists?(File.join(@site.root,'public','test.html'))
    assert_equal item.render, File.read(File.join(@site.root,'public','test.html'))
  end

  def test_markdown_template
    item = Jenner::Item.new('markdown_test.markdown', @site)
    assert_equal "top\nmarkdown test\n2014-01-23 17:02:00 -0600\nwrapper\n\n<h1 id=\"markdown_test\">markdown test</h1>\n\n<p>item content</p>\n\nbottom\n", item.render
  end

  def test_markdown_template_public_path
    item = Jenner::Item.new('markdown_test.markdown', @site)
    assert_equal site_file('public/markdown_test.html'), item.public_path
  end

  def test_public_path_on_subdir_item
    item = Jenner::Item.new("subdirectory/subfile.html",@site)
    assert_equal site_file("public/subdirectory/subfile.html"), item.public_path
  end

  def test_generate_on_subdir_item
    item = Jenner::Item.new("subdirectory/subfile.html",@site)
    FileUtils.mkdir_p(File.join(@site.root,'public','subdirectory'))
    item.generate!
    assert File.exists?(File.join(@site.root,'public','subdirectory','subfile.html'))
    assert_equal "item: subfile\n\n", File.read(File.join(@site.root,'public','subdirectory','subfile.html'))
  end

  def test_url
    item = Jenner::Item.new('test.html',@site)
    assert_equal "/test.html", item.url
  end

  def test_url_on_subdir_item
    item = Jenner::Item.new('subdirectory/subfile.html',@site)
    assert_equal "/subdirectory/subfile.html", item.url
  end

  def test_underscored_title
    item = Jenner::Item.new('blog/20140128_test_post.markdown', @site)
    assert_equal "test-post", item.underscored_title
  end

  def test_relative_path
    item = Jenner::Item.new('blog/20140128_test_post.markdown', @site)
    assert_equal "blog/", item.relative_path
  end

  def test_output_filename_on_custom_url
    item = Jenner::Item.new('blog/20140128_test_post.markdown', @site)
    assert_equal "index.html", item.output_filename
  end

  def test_output_filename_on_regular_markdown_file
    item = Jenner::Item.new('markdown_test.markdown', @site)
    assert_equal "markdown_test.html", item.output_filename
  end

  def test_custom_url
    item = Jenner::Item.new('blog/20140128_test_post.markdown', @site)
    assert_equal "/blog/2014/01/28/test-post", item.url
  end

  def test_public_path_on_custom_url
    item = Jenner::Item.new('blog/20140128_test_post.markdown', @site)
    assert_equal site_file("public/blog/2014/01/28/test-post/index.html"), item.public_path
  end

  def test_generate_on_custom_url
    item = Jenner::Item.new('blog/20140128_test_post.markdown', @site)
    item.generate!
    assert File.exists?(site_file("public/blog/2014/01/28/test-post/index.html"))
  end

  def test_item_from_path
    item = Jenner::Item.new('embed_test.html', @site)
    assert_equal "\nsecret: 42\n\n", item.body
  end
end
