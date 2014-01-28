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

  def test_generate_creates_subdirectories
    @site.generate!
    assert Dir.exists?(File.join(@site.root,'public','subdirectory'))
  end

  def test_copies_files_in_subdirectories
    @site.generate!
    assert File.exists?(File.join(@site.root,'public','subdirectory','test.png'))
  end

  def test_creates_items_in_subdirectories
    @site.generate!
    assert File.exists?(File.join(@site.root,'public','subdirectory','subfile.html'))
  end

  def test_underscored_items_dont_get_copied
    @site.generate!
    assert !File.exists?(site_file('public/_hidden.html'))
  end

  def test_generates_sass
    @site.generate!
    assert File.exists?(site_file("public/test.css"))
    assert_equal "body {\n  background-color: blue; }\n", File.read(site_file("public/test.css"), encoding: "US-ASCII")
  end

  def test_asset_files
    assert @site.asset_files.include? site_file('_site/test.scss')
  end

  def test_tag_names
    assert_equal ['one',"three","two"], @site.tag_names.sort
  end

  def test_tags
    assert @site.tags.first.is_a? Jenner::Tag
  end
end
