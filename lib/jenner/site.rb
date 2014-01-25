module Jenner
  class Site
    attr_reader :root
    def initialize(root)
      @root = root

      Liquid::Template.file_system = Jenner::TemplateFileSystem.new(File.join(@root,'_templates'))
    end

    def site_path
      File.join(@root,"_site")
    end

    def files
      Dir.glob(File.join(site_path,"[^_]*.{html,markdown}")) +
        Dir.glob(File.join(site_path,"**","[^_]*.{html,markdown}"))
    end

    def relative_path(item)
      (item.split("/") - site_path.split("/")).join("/")
    end

    def items
      files.inject([]) { |a,i|
        a << Jenner::Item.new(relative_path(i), self)
      }
    end

    def public_dir
      File.join(@root, "public")
    end

    def site_dir
      File.join(@root, "_site")
    end

    def site_dirs
      site_dir.split("/")
    end

    def relative_path_to_public(item)
      (item.split("/") - site_dirs).join("/")
    end

    def generate!
      FileUtils.rm_rf(public_dir)
      FileUtils.mkdir(public_dir)

      base_dirs = File.join(site_dir).split("/")
      Dir.glob(File.join(@root,"_site","**","*")).each do |item|
        if File.directory?(item)
          FileUtils.mkdir_p(File.join(public_dir,relative_path_to_public(item)))
        else
          next if [".html",".markdown"].include? File.extname(item)
          destination = File.join(public_dir,relative_path_to_public(item))
          FileUtils.cp item, destination
        end
      end
      items.map(&:generate!)
    end
  end
end
