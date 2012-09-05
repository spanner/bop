require "liquid"

module Bop
  module Tags
    
    class Yield < Liquid::Tag
      include ActionView::Helpers::TagHelper
      
      def initialize(tag_name, space_name, tokens)
         super
         space_name = "main" if !space_name || space_name.blank?
         @space = space_name
      end

      def render(context)
        if page = Bop::Page.find(context["page"]["id"])
          output = page.blocks_in(@space.downcase).each_with_object(''.html_safe) do |block, op|
            op << content_tag(:section, block.render(context), :class => 'block', :"data-bop-block" => block.id)
          end
          content_tag :section, output, :class => 'space', :"data-bop-space" => @space
        end
      end
    end

    Liquid::Template.register_tag('yield', Bop::Tags::Yield)






    class Stylesheet < Liquid::Tag
      def initialize(tag_name, slug, tokens)
         super
         @stylesheet = Bop.site.stylesheets.find_by_title(slug)
      end

      def render(context)
        %{<link href="#{bop_stylesheet_path(@stylesheet)}" media="screen" rel="stylesheet" type="text/css" />}
      end
    end

    Liquid::Template.register_tag('stylesheet', Bop::Tags::Stylesheet)

  end
end

