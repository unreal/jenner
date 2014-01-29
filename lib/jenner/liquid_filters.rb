module Jenner
  module LiquidFilters

    def asset_from_path(path)
      @context.registers[:site].assets.find { |asset| asset.path == path } || "Asset with path '#{path}' not found"
    end

    def item_from_path(path)
      @context.registers[:site].items.find { |item| item.local_path == path } || "Item with path '#{path}' not found"
    end

    def items_from_path(path)
      @context.registers[:site].items.select {|item| item.local_path =~ /^#{path}/ } || []
    end

    def tag(name)
      @context.registers[:site].tags.find { |tag| tag.name == name } || "Tag with name '#{name}' not found"
    end

    def items_with_data(key, value=nil)
      key_matches = @context.registers[:site].items.select { |item|
        item.data.keys.include?(key)
      }
      return key_matches if value.nil?

      # value was provided
      key_matches.select do |item|
        if item.data[key].is_a?(Array)
          item.data[key].include?(value)
        else
          item.data[key] == value
        end
      end
    end

    def assign_to(value, name)
      @context[name] = value
      nil
    end

    def stylesheet_tag(path)
      %(<link href="#{path}" media="all" rel="stylesheet" type="text/css" />)
    end

    def javascript_tag(path)
      %(<script type="text/javascript" src="#{path}"></script>)
    end

    def link_to(item)
      %(<a href="#{item.url}">#{item.title}</a>)
    end

  end
end

Liquid::Template.register_filter(Jenner::LiquidFilters)
