# Jenner

Jenner is a static site generator, named after another Doctor.

![Jenner](http://images.wikia.com/walkingdead/images/archive/3/38/20120814183308!Dr_Edwin_Jenner_TV,_1.jpg)

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
    {{item.url}}   => "/example.html"

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

Every item provides the following data at minimum:

    {{item.title}}
    {{item.date}}
    {{item.template_name}}
    {{item.body}}
    {{item.url}}

Additional pieces of data are available within `{{item.data}}` if they
are defined in the item's YAML header.

You can include other templates with the `{% include %}` tag.

    {% include 'header' %}
    {{item.body}}
    {% include 'footer' %}

### Assets

All your other files/subdirectories will be copied over as-is with two
exceptions:

1. [Sass](http://sass-lang.com/) `.scss` files will be processed and copied over as `.css`
2. Filenames starting with _ will be ignored (e.g. _hidden.html)

### Tags

Tags are a special addition to the YAML header. You can specify them as
a YAML string array e.g.:

    ---
    title:    'Example Page'
    date:     2014-01-23 17:02:00 -6
    template: 'page'
    tags:     [one, two, three]
    ---

You will have access to the tag names in {{item.tags}}. You can also get
a tag by name with a Liquid filter.

    {{ 'one' | tag | assign_to: my_tag }}

    {% for item in my_tag.items %}
      {{item.body}}
    {% endfor %}


### Other Liquid Filters

I personally dislike having to write specialized plugins or generators
to generate my site. By simply adding a couple of filters to Liquid, we
can easily do just about anything on the item/page level without having
to write anymore outside Ruby.

    <h1>Page rendering two items</h1>
    {{ 'item_one.html' | item_from_path | assign_to: item_one }}
    {{ 'item_two.html' | item_from_path | assign_to: item_two }}

    <table>
      <tr>
        <th>{{item_one.title}}</th>
        <th>{{item_two.title}}</th>
      </tr>
      <tr>
        <td>{{item_one.body}}</td>
        <td>{{item_two.body}}</td>
      </tr>
    <table>

Some other useful helpers:

    {{ 'test.css' | stylesheet_tag }}
    {{ 'test.js'  | javascript_tag }}
    {{ 'page_one.html' | item_from_path | link_to }}
    {{ 'test.gif' | asset_from_path | assign_to: my_image }}
    <img src="{{my_image.url}}" />


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
