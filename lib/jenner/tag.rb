module Jenner
  class Tag
    attr_reader :name
    def initialize(name, site)
      @name = name
      @site = site
    end

    def items
      @items ||= @site.items.select { |item|
        item.tags.include?(@name)
      }.inject([]) {|a, item|
        a << item
      }
    end

    def to_liquid
      {
        "name"  => @name,
        "items" => items
      }
    end
  end
end
