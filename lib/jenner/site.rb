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

    def all_files
      @all_files ||= Dir.glob(File.join(site_path,"**","[^_]*.*"))
    end

    def item_files
      @item_files ||= all_files.select {|f| ['.html','.markdown'].include? File.extname(f) }
    end

    def asset_files
      @asset_files ||= all_files - item_files
    end

    def relative_path(item)
      (item.split("/") - site_path.split("/")).join("/")
    end

    def assets
      @assets ||= asset_files.inject([]) { |a,asset|
        a << Jenner::Asset.new(relative_path(asset), self)
      }
    end

    def items
      @items ||= item_files.inject([]) { |a, item|
        a << Jenner::Item.new(relative_path(item), self)
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

    def tag_names
      @tag_names ||= items.inject([]) {|a,i|
        a << i.tags
      }.flatten.uniq
    end

    def tags
      @tags ||= tag_names.inject([]) { |a,tag|
        a << Jenner::Tag.new(tag, self)
      }
    end

    def relative_path_to_public(item)
      (item.split("/") - site_dirs).join("/")
    end

    def create_directories!
      Dir.glob(File.join(@root,"_site","**")).each do |dir|
        next unless File.directory?(dir)

        FileUtils.mkdir_p(File.join(public_dir,relative_path_to_public(dir)))
      end
    end

    def generate!
      FileUtils.rm_rf(public_dir)
      FileUtils.mkdir(public_dir)

      create_directories!

      assets.map(&:generate!)
      items.map(&:generate!)
    end
  end
end
