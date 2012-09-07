require "liquid"

module Bop
  module Tags
    
    ## {{ yield [space name] }}
    #
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
            op << content_tag(:article, block.render(context), :class => 'block', :"data-bop-block" => block.id)
          end
          content_tag :section, output, :class => 'space', :"data-bop-space" => @space
        end
      end
    end

    Liquid::Template.register_tag('yield', Bop::Tags::Yield)

    ## {{ stylesheet [name] }}
    #
    #
    class Stylesheet < Liquid::Tag
      def initialize(tag_name, slug, tokens)
         super
         @slug = slug.strip
         @stylesheet = Bop.site.stylesheets.find_by_title(@slug)
      end

      def render(context)
        if @stylesheet
          %{<link href="/bop/css/#{@slug}.css" media="screen" rel="stylesheet" type="text/css" data-wysihtml5="custom_css"/>}
        else
          %{<!-- stylesheet '#{@slug}' could not be found -->}
        end
      end
    end

    Liquid::Template.register_tag('stylesheet', Bop::Tags::Stylesheet)

    ## {{ javascript [name] }}
    #
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

