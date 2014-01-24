module Jenner
  class Item
    attr_reader :body, :title, :date, :template_name
    def initialize(filename, site)
      @filename = filename
      @site     = site

      @body = File.read(File.join(@site.root,'_site',@filename), encoding: "US-ASCII")

      if @body =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
        @body   = $'
        @header = Psych.load($1)
      end

      @title         = @header["title"]
      @date          = @header["date"]
      @template_name = @header["template"]
    end

    def template
      Jenner::Template.from_file(File.join(@site.root,'_templates',"#{@template_name}.html"), @site)
    end

    def to_liquid
      {
        'title'         => @title,
        'date'          => @date,
        'template_name' => @template_name,
      }
    end

    def body
      Liquid::Template.parse(@body).render('self' => self)
    end

    def render
      template.render(
        'item' => self.to_liquid.merge('body' => body)
      )
    end
  end
end
