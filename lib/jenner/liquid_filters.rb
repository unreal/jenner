module Jenner
  module LiquidFilters

    def asset_from_path(path)
      @context.registers[:site].assets.find { |asset| asset.path == path } || "Asset with path '#{path}' not found"
    end

    def item_from_path(path)
      @context.registers[:site].items.find { |item| item.path == path } || "Item with path '#{path}' not found"
    end

    def tag(name)
      @context.registers[:site].tags.find { |tag| tag.name == name } || "Tag with name '#{name}' not found"
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
