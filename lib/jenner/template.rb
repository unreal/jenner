module Jenner
  class Template
    attr_reader :body
    def initialize(body, site)
      @body = body
      @site = site
    end

    def render(context)
      Liquid::Template.parse(@body).render(context)
    end

    def self.from_file(file_path, site)
      new(File.read(file_path, encoding: 'US-ASCII'), site)
    end
  end
end
