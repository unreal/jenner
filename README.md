# Jenner

Jenner is a static site generator.

## Installation

Add this line to your application's Gemfile:

    gem 'jenner'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jenner

## Usage

TODO: add a `jenner new` command to create site skeleton

1. `mkdir my_jenner_site`
2. `cd my_jenner_site`
3. `mkdir _site`
4. `mkdir _templates`
5. Create a template in `_templates` (e.g. page.html)
6. Start creating items (pages) in `_site`
7. `jenner build`

Your generated site will be in `./public`.

### Items

Here's an example (example.html):

    ---
    title:    'Example Page'
    date:     2014-01-23 17:02:00 -6
    template: 'page'
    ---

    <p>This is an example page.</p>

This item will be rendered using the `page` template. The `page`
template can use the following data:

    {{item.title}} => "Example Page"
    {{item.data}}  => 2014-01-23 17:02:00 -6
    {{item.template_name}} => "page"
    {{item.body}}  => "<p>This is an example page.</p>

You can define additional pieces of data in the item header like this:

    ---
    title:    'Example Page'
    date:     2014-01-23 17:02:00 -6
    template: 'page'
    foo:      'bar'
    answer:   42
    ---

This item has a couple additional pieces of data:

    {{item.data.foo}}    => "bar"
    {{item.data.answer}} => 42

You can also create markdown items with the file extension `.markdown`.
These will be go through the Liquid templating engine first, and then
they will be processed as Markdown.

    ---
    title:    'Example Markdown Page'
    date:     2014-01-23 17:02:00 -6
    template: 'page'
    ---

    # This is an example page


### Templates

Templates are just HTML files that use Liquid markup. Every item you
create is rendered with a template that you specify in the item's
header.

You can include other templates with the `{% include %}` tag.

    {% include 'some_other_template' %}


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
