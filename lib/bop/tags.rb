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
            op << content_tag :section, block.render(context), :class => 'block'
          end
          content_tag :section, output, :class => 'space'
        end
      end
    end

    Liquid::Template.register_tag('yield', Bop::Tags::Yield)
  end
end
