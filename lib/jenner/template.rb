# encoding: UTF-8
module Jenner
  class Template
    def initialize(body, site, options={})
      @body = body
      @site = site
      @haml = options[:haml]
    end

    def haml?
      @haml
    end

    def body(context={})
      haml? ? Haml::Engine.new(@body).render(Object.new, context) : @body
    end

    def render(context={})
      Liquid::Template.parse(body(context.merge('site' => @site))).render(context.merge('site' => @site), registers: { site: @site }).to_s.encode("utf-8")
    end

    def self.from_file(file_path, site)
      if File.extname(file_path) != ".haml"
        new(File.read(file_path), site)
      else
        from_haml(File.read(file_path), site)
      end
    end

    def self.from_haml(haml_body, site)
      new(haml_body, site, haml: true)
    end
  end
end
