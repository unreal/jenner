# encoding: UTF-8
module Jenner
  class Template
    attr_reader :body
    def initialize(body, site)
      @body = body
      @site = site
    end

    def render(context)
      Liquid::Template.parse(@body).render(context, registers: { site: @site })
    end

    def self.from_file(file_path, site)
      new(File.read(file_path), site)
    end
  end
end
