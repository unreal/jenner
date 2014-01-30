require "bundler/setup"
require "haml"
require "liquid"
require "maruku"
require "ostruct"
require "sass"
require "webrick"

require "jenner/asset"
require "jenner/item"
require "jenner/liquid_filters"
require "jenner/site"
require "jenner/tag"
require "jenner/template"
require "jenner/template_file_system"
require "jenner/version"

module Jenner
  def self.build(args, options={})
    @site = Site.new(File.expand_path('.'))
    puts "Building a site at #{@site.root}"
    @site.generate!
  end

  def self.serve(args, options={})
    root = File.expand_path("./public")
    if Dir.exists?(root)
      puts "Starting server on port 9191"
      server = WEBrick::HTTPServer.new :Port => 9191, :DocumentRoot => root
      trap 'INT' do server.shutdown end

      server.start
    else
      puts "Site does not appear to be built. Run 'jenner build' first"
    end
  end

  def self.deep_struct(obj)
    case obj
    when Hash
      obj = obj.clone
      obj.each do |key,value|
        obj[key] = Jenner.deep_struct(value)
      end
      OpenStruct.new(obj)
    when Array
      obj = obj.clone
      obj.map! {|i| Jenner.deep_struct(i) }
    else
      obj
    end
  end
end
