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
end
