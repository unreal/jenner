# encoding: utf-8
module Jenner
  class TemplateFileSystem
    attr_reader :root
    def initialize(root)
      @root = root
      @pattern =  "%s"
    end

    def read_template_file(template_path, context)
      full_path = full_path(template_path)
      raise FileSystemError, "No such template '#{template_path}'" unless File.exists?(full_path)

      if File.extname(template_path) == ".haml"
        Haml::Engine.new(File.read(full_path)).render
      else
        File.read(full_path)
      end
    end

    def full_path(template_path)
      #raise Liquid::FileSystemError, "Illegal template name '#{template_path}'" unless template_path =~ /^[^.\/][a-zA-Z0-9_\/]+$/

      full_path = if template_path.include?('/')
        File.join(root, File.dirname(template_path), @pattern % File.basename(template_path))
      else
        File.join(root, @pattern % template_path)
      end

      raise Liquid::FileSystemError, "Illegal template path '#{File.expand_path(full_path)}'" unless File.expand_path(full_path) =~ /^#{File.expand_path(root)}/

      full_path
    end
  end
end
