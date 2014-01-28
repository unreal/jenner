require 'helper'

class TestAsset < Test::Unit::TestCase
  def setup
    super
    @asset = Jenner::Asset.new('test.scss', @site)
  end

  def test_filename
    assert_equal "test.scss", @asset.filename
  end

  def test_sass
    assert @asset.sass?
  end

  def test_sass_on_an_image
    @asset = Jenner::Asset.new("subdirectory/test.png", @site)
    assert !@asset.sass?
  end

  def test_output_filename
    assert_equal "test.css", @asset.output_filename
  end

  def test_url
    assert_equal "/test.css", @asset.url
  end

  def test_public_path
    assert_equal site_file("public/test.css"), @asset.public_path
  end

  def test_generate
    FileUtils.mkdir(File.join(@site.root,"public"))
    @asset.generate!
    assert File.exists?(File.join(@site.root,"public","test.css"))
  end

  def test_generate_on_non_sass
    FileUtils.mkdir(File.join(@site.root,"public"))
    @asset = Jenner::Asset.new("foo.txt", @site)
    @asset.generate!
    assert File.exists?(File.join(@site.root,"public","foo.txt"))
  end

  def test_to_liquid
    assert_equal({'url' => @asset.url}, @asset.to_liquid)
  end
end
