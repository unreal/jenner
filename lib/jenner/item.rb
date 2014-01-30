# encoding: utf-8
module Jenner
  class Item
    attr_reader :title, :date, :template_path, :data, :tags
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
        @template_path = @header.delete("template")
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

    def local_path
      @path
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
      @title.gsub(/[^\w]+/,"-").downcase
    end

    def formatted_url
      "/#{relative_path}#{@date.strftime(@url_format).gsub(":title", underscored_title)}"
    end

    def template
      Jenner::Template.from_file(File.join(@site.root,'_templates',"#{@template_path}"), @site)
    end

    def to_liquid_without_body
      {
        'title'         => @title,
        'date'          => @date,
        'template_path' => @template_path,
        'tags'          => @tags,
        'data'          => @data,
        'url'           => url,
        'site'          => @site
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

    def liquid_body
      Liquid::Template.parse(@body).render({'self' => self.to_liquid_without_body}, registers: { site: @site })
    end

    def body
      if haml?
        Haml::Engine.new(liquid_body).render(Jenner.deep_struct(self.to_liquid_without_body), :site => Jenner.deep_struct(@site.to_liquid))
      elsif markdown?
        Maruku.new(liquid_body).to_html
      else
        liquid_body
      end
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
