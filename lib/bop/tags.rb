require "liquid"

module Bop
  module Tags
    
    ## {{ yield [space name] }}
    #
    class Yield < Liquid::Tag
      include ActionView::Helpers::TagHelper
      
      def initialize(tag_name, space_name, tokens)
         super
         space_name = "main" if !space_name || space_name.blank?
         @space = space_name.rstrip
      end

      def render(context)
        if page = Bop::Page.find(context["page"]["id"])
          output = page.blocks_in(@space.downcase).each_with_object(''.html_safe) do |block, op|
            id = Bop::PlacedBlock.find_by_space_name_and_block_id(@space, block.id).id
            op << content_tag(:article, block.render(context), :class => 'block', :"data-bop-block" => block.id, :id => "placed_block_#{id}")
          end
          content_tag :section, output, :class => 'space', :"data-bop-space" => @space
        end
      end
    end

    Liquid::Template.register_tag('yield', Bop::Tags::Yield)

    ## {{ pagefield [field] }}
    #
    class Pagefield < Liquid::Tag
      
      def initialize(tag_name, field, tokens)
         super
         @field = field.strip
      end
      
      def render(context)
        page = Bop::Page.find(context["page"]["id"])
        id = page.id
        field = @field
        value = page.send(field)
        "<span id='page#{field}' data-bop-field=#{field}>#{value}</span>"
      end
    end

    Liquid::Template.register_tag('pagefield', Bop::Tags::Pagefield)

    ## {{ collection [class_name] }}
    #
    class Collection < Liquid::Tag
      
      def initialize(tag_name, class_name, tokens)
         super
         @class_name = class_name.strip
      end
      
      def render(context)
        collection_name = ActiveSupport::Inflector.pluralize(@class_name)
        page = Bop::Page.find(context["page"]["id"])
        anchor = page.site.anchor
        collection = anchor.send(collection_name)
        block = []
        collection.each do |object|
          block.push "<li class='leg' data-url='/#{collection_name}/#{object.id}'>position: #{object.position}, distance: #{object.distance}, climb: #{object.climb}</li>"
        end
        block
      end
    end

    Liquid::Template.register_tag('collection', Bop::Tags::Collection)

    ## {{ stylesheet [name] }}
    #
    class Stylesheet < Liquid::Tag
      def initialize(tag_name, slug, tokens)
         super
         @slug = slug.strip
         @stylesheet = Bop.site.stylesheets.find_by_title(@slug)
      end

      def render(context)
        if @stylesheet
          %{<link href="/bop/css/#{@slug}.css" media="screen" rel="stylesheet" type="text/css" />}
        else
          %{<!-- stylesheet '#{@slug}' could not be found -->}
        end
      end
    end

    Liquid::Template.register_tag('stylesheet', Bop::Tags::Stylesheet)

    ## {{ javascript [name] }}
    #
    class Javascript < Liquid::Tag
      def initialize(tag_name, slug, tokens)
         super
         @slug = slug.strip
         @javascript = Bop.site.javascripts.find_by_title(@slug)
      end

      def render(context)
        if @javascript
          %{<script src="/bop/js/#{@slug}.js" type="text/javascript" ></script>}
        else
          %{<!-- javascript '#{@slug}' could not be found -->}
        end
      end
    end

    Liquid::Template.register_tag('javascript', Bop::Tags::Javascript)

  end
end

