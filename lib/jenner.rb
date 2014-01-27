require "bundler/setup"
require "liquid"
require "maruku"
require "sass"

require "jenner/item"
require "jenner/liquid_filters"
require "jenner/site"
require "jenner/template"
require "jenner/template_file_system"
require "jenner/version"

module Jenner
  def self.build(args, options={})
    @site = Site.new(File.expand_path('.'))
    puts "Building a site at #{@site.root}"
    @site.generate!
  end
end
