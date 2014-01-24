require 'helper'

class TestTemplate < Test::Unit::TestCase
  def test_initialize_with_a_string
    template = Jenner::Template.new("test", @site)
    assert_equal "test", template.body
  end

  def test_render_with_a_hash_context_returns_a_rendered_liquid_template
    template = Jenner::Template.new("hi, {{name}}", @site)
    assert_equal "hi, jay", template.render('name' => 'jay')
  end

  def test_initialize_from_file
    template = Jenner::Template.from_file(template_file('test.html'), @site)
    assert_equal "hi, {{name}}\n", template.body
  end

  def test_include
    template = Jenner::Template.new("{% include 'test' %}", @site)
    assert_equal "hi, jay\n", template.render('name' => 'jay')
  end
end
