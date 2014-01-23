require 'bundler/setup'
require 'test-unit'
require 'jenner'

module Test
  module Unit
    class TestCase
      def template_file(file_name)
        File.join(File.dirname(__FILE__),'fixtures','source','_templates',file_name)
      end

      def site_file(path)
        File.join(File.dirname(__FILE__),'fixtures','source','_site',path)
      end
    end
  end
end
