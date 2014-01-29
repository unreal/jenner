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

Items can be created as HTML or [Haml](http://haml.info/) files.

Here's an example HTML item:

    ---
    title:    'Example Page'
    date:     2014-01-23 17:02:00 -6
    template: 'page.html'
    ---

    <h1>{{self.title}}</h1>
    <p>This is an example page.</p>

Here's the same example using Haml + Liquid:

    ---
    title:    'Example Page'
    date:     2014-01-23 17:02:00 -6
    template: 'page.html'
    ---

    %h1 {{self.title}}
    %p This is an example page.

Here's the same example using Haml directly, not Liquid:

    ---
    title:    'Example Page'
    date:     2014-01-23 17:02:00 -6
    template: 'page.html'
    ---

    %h1= self.title
    %p This is an example page.

It's your choice: HTML, HTML + Liquid, Haml, Haml+ Liquid.

This item will be rendered using the `page` template. The `page`
template can use the following data:

    {{item.title}} => "Example Page"
    {{item.data}}  => 2014-01-23 17:02:00 -6
    {{item.template_path}} => "page.html"
    {{item.body}}  => "<p>This is an example page.</p>
    {{item.url}}   => "/example.html"

You can define additional pieces of data in the item header like this:

    ---
    title:    'Example Page'
    date:     2014-01-23 17:02:00 -6
    template: 'page.html'
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
    template: 'page.html'
    ---

    # This is an example page

### Templates

Templates are just HTML or [Haml](http://haml.info/) files that use
Liquid markup. Every item you create is rendered with a template that
you specify in the item's header via the `template` attribute.

Haml templates can use Liquid, but they don't have to. You could simply
use the template's context in Haml:

    %h1= item.title
    = item.body

instead of:

    %h1 {{item.title}}
    {{item.body}}

Every item provides the following data at minimum:

    {{item.title}}
    {{item.date}}
    {{item.template_path}}
    {{item.body}}
    {{item.url}}
    {{site}}

Additional pieces of data are available within `{{item.data}}` if they
are defined in the item's YAML header.

You can include other templates with the `{% include %}` tag.

    {% include 'header.html' %}
    {{item.body}}
    {% include 'footer.html' %}

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
    template: 'page.html'
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

    <h1>Bunch of items</h1>
    {{ 'blog\/' | items_from_path | assign_to: blog_posts }}
    {% for blog_post in blog_posts %}
      do something with {{blog_post}} here
    {% endfor %}

Some other useful helpers:

    {{ 'test.css' | stylesheet_tag }}
    {{ 'test.js'  | javascript_tag }}
    {{ 'page_one.html' | item_from_path | link_to }}
    {{ 'test.gif' | asset_from_path | assign_to: my_image }}
    <img src="{{my_image.url}}" />

You can also use a couple of filters to grab items by custom data or
custom data and value combination. For example, say you have a few items
with an author attribute.

    {{'author' | items_with_data | assign_to: items_with_author_defined}}

Or maybe you just want a certain author:

    {{'author' | items_with_data: 'Mark Twain' | assign_to: items_twain_wrote }}

If the custom data you created can be an array, it works on that too:

    {{'favorite_colors' | items_with_data: 'blue' | assign_to: items_who_like_blue_and_possibly_other_colors }}

### Custom URL Formatting

By default, all items will be copied over as-is e.g. if your item
resides in /blog/2014/0128_test_post.html it will end up in
/public/blog/2014/0128_test_post.html.

You can specify a custom url_format parameter in your YAML item header.

    ---
    title:      'test post'
    date:       2014-01-28 15:23:00 -6
    template:   'post.html'
    url_format: '%Y/%m/%d/:title'
    ---

The formatting will be relative to whatever directory the file resides
in, and will be processed by using [Ruby's Time#strftime](http://www.ruby-doc.org/core-1.9.3/Time.html#method-i-strftime)
method on the item's date, and `:title` will be replaced with an
underscored version of your site's title.

If the above example post resides in /blog, the output file will go to:
/public/blog/2014/01/28/test-post/index.html. The `{{item.url}}`
parameter will not include the index.html to keep things pretty. It will
be: `/blog/2014/01/28/test-post`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
