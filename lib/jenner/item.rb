# encoding: utf-8
module Jenner
  class Item
    attr_reader :title, :date, :template_name, :data, :tags
    def initialize(path, site)
      @path     = path
      @site     = site

      @body = File.read(File.join(@site.root,'_site',@path))

      if @body =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
        @body   = $'
        @header = YAML.load($1)
      end

      begin
        @title         = @header.delete("title")
        @date          = @header.delete("date")
        @template_name = @header.delete("template")
        @tags          = @header.delete("tags") || []
        @url_format    = @header.delete("url_format")
        @data          = @header
      rescue Exception => e
        raise "Invalid header data on item at path: #{@path}"
      end
    end

    def relative_path
      path = File.dirname(@path)
      return "" if path == "."

      "#{path}/"
    end

    def path
      return @path if @url_format.nil?

      if File.extname(url) == ""
        "#{url}/index.html"
      else
        url
      end
    end

    def output_filename
      return "index.html" if File.extname(url) == ""

      File.basename(@path).sub(".markdown",".html")
    end

    def input_filename
      File.extname(@path)
    end

    def url
      @url_format.nil? ? "/#{@path.sub(".markdown",".html")}" : formatted_url
    end

    def underscored_title
      @title.gsub(/[^\w]+/,"-")
    end

    def formatted_url
      "/#{relative_path}#{@date.strftime(@url_format).gsub(":title", underscored_title)}"
    end

    def template
      Jenner::Template.from_file(File.join(@site.root,'_templates',"#{@template_name}.html"), @site)
    end

    def to_liquid_without_body
      {
        'title'         => @title,
        'date'          => @date,
        'template_name' => @template_name,
        'tags'          => @tags,
        'data'          => @data,
        'url'           => url,
      }
    end

    def to_liquid
      to_liquid_without_body.merge(
        'body' => body
      )
    end

    def markdown?
      File.extname(@path) == ".markdown"
    end

    def haml?
      File.extname(@path) == ".haml"
    end

    def markdown(s)
      return s unless markdown?

      Maruku.new(s).to_html
    end

    def haml(s)
      return s unless haml?

      Haml::Engine.new(s).render
    end

    def body
      post_process Liquid::Template.parse(@body).render({'self' => self.to_liquid_without_body}, registers: { site: @site })
    end

    def post_process(s)
      s = markdown(s)
      s = haml(s)
      s
    end

    def render
      template.render(
        'item' => self.to_liquid
      )
    end

    def public_path
      File.join(@site.root,'public',path.sub('.markdown','.html').sub(".haml",".html"))
    end

    def generate!
      return if File.basename(public_path)[0] == "_"

      FileUtils.mkdir_p(File.dirname(public_path))
      File.write(public_path,render)
    end
  end
end
