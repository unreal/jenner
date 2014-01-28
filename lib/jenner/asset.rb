module Jenner
  class Asset
    attr_reader :path
    def initialize(path, site)
      @path = path
      @site = site
    end

    def filename
      File.basename(@path)
    end

    def sass?
      File.extname(filename) == ".scss"
    end

    def output_filename
      sass? ? filename.sub(".scss",".css") : filename
    end

    def source_path
      File.join(@site.root,"_site",@path)
    end

    def output_path
      @path.sub(filename, output_filename)
    end

    def url
      "/#{output_path}"
    end

    def public_path
      File.join(@site.root,"public", output_path)
    end

    def to_liquid
      {
        'url' => url
      }
    end

    def generate!
      if sass?
        engine = Sass::Engine.new(File.read(source_path), syntax: :scss)
        File.write(public_path, engine.render)
      else
        FileUtils.cp source_path, public_path
      end
    end
  end
end
