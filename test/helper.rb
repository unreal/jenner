require 'bundler/setup'
require 'test-unit'
require 'jenner'

module Test
  module Unit
    class TestCase
      def setup
        @site = Jenner::Site.new(File.join(File.dirname(__FILE__),'fixtures','source'))
      end

      def template_file(file_name)
        File.join(File.dirname(__FILE__),'fixtures','source','_templates',file_name)
      end

      def site_file(path)
        File.join(File.dirname(__FILE__),'fixtures','source', path)
      end
    end
  end
end
