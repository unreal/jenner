module Jenner
  class Site
    attr_reader :root
    def initialize(root)
      @root = root

      Liquid::Template.file_system = Jenner::TemplateFileSystem.new(File.join(@root,'_templates'))
    end

    def items
      Dir.glob(File.join(@root,"_site","*.{html,markdown}")).inject([]) { |a,i| a << Jenner::Item.new(File.basename(i), self) }
    end

    def generate!
      items.map(&:generate!)
    end
  end
end
