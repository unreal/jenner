module Jenner
  class Template
    attr_reader :body
    def initialize(body)
      @body = body
    end

    def render(context)
      ::Liquid::Template.parse(@body).render(context)
    end

    def self.from_file(file_path)
      new(File.read(file_path, encoding: 'US-ASCII'))
    end
  end
end
