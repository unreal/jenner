module Jenner
  class Item
    attr_reader :body, :title, :date, :template_name, :data
    def initialize(filename, site)
      @filename = filename
      @site     = site

      @body = File.read(File.join(@site.root,'_site',@filename), encoding: "US-ASCII")

      if @body =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
        @body   = $'
        @header = YAML.load($1)
      end

      @title         = @header.delete("title")
      @date          = @header.delete("date")
      @template_name = @header.delete("template")
      @tags          = @header.delete("tags")
      @data          = @header
    end

    def url
      "/#{@filename}"
    end

    def template
      Jenner::Template.from_file(File.join(@site.root,'_templates',"#{@template_name}.html"), @site)
    end

    def to_liquid
      {
        'title'         => @title,
        'date'          => @date,
        'template_name' => @template_name,
        'tags'          => @tags,
        'data'          => @data,
        'url'           => url
      }
    end

    def markdown(s)
      return s unless @filename.split('.').last == "markdown"

      Maruku.new(s).to_html
    end

    def body
      markdown(Liquid::Template.parse(@body).render('self' => self))
    end

    def render
      template.render(
        'item' => self.to_liquid.merge('body' => body)
      )
    end

    def public_path
      File.join(@site.root,'public',@filename)
    end

    def generate!
      File.write(public_path,render)
    end
  end
end
