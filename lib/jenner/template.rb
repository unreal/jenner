# encoding: UTF-8
module Jenner
  class Template
    attr_reader :body
    def initialize(body, site)
      @body = body
      @site = site
    end

    def render(context={})
      Liquid::Template.parse(@body).render(context, registers: { site: @site })
    end

    def self.from_file(file_path, site)
      if File.extname(file_path) != ".haml"
        new(File.read(file_path), site)
      else
        from_haml(File.read(file_path), site)
      end
    end

    def self.from_haml(haml_body, site)
      new(Haml::Engine.new(haml_body).render, site)
    end
  end
end
