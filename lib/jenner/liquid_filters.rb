module Jenner
  module LiquidFilters
    def item_from_path(path)
      Jenner::Item.new(path, @context.registers[:site])
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
