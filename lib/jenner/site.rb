module Jenner
  class Site
    attr_reader :root
    def initialize(root)
      @root = root
    end

    def items
      Dir.glob(File.join(@root,"_site","*.html")).inject([]) { |a,i| a << i }
    end

    def generate
      items.each do |i|

      end
    end
  end
end
