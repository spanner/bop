require "liquid"

module Bop
  module LiquidTags
    
    ## {{ space [space name] }}
    #
    class Space < Liquid::Tag
      include ActionView::Helpers::TagHelper
      
      def initialize(tag_name, space_name, tokens)
         super
         space_name = "main" if !space_name || space_name.blank?
         @space = space_name.strip
      end

      def render(context)
        if page = Bop::Page.find(context["page"]["id"])
          output = page.render_space(@space)
        end
      end
    end

    Liquid::Template.register_tag('space', Bop::LiquidTags::Space)

    ## {{ field [field] }}
    #
    class Field < Liquid::Tag
      
      def initialize(tag_name, field, tokens)
         super
         @field = field.strip
      end
      
      def render(context)
        page = Bop::Page.find(context["page"]["id"])
        page.render_field(@field)
      end
    end

    Liquid::Template.register_tag('field', Bop::LiquidTags::Field)















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

    Liquid::Template.register_tag('collection', Bop::LiquidTags::Collection)

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

    Liquid::Template.register_tag('stylesheet', Bop::LiquidTags::Stylesheet)

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

    Liquid::Template.register_tag('javascript', Bop::LiquidTags::Javascript)

  end
end

