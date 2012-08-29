require "liquid"

module Bop
  module Tags
    
    class Yield < Liquid::Tag
      def initialize(tag_name, space_name, tokens)
         super
         @space = space_name || "main"
      end

      def render(context)
        if page = context['page']
          page.blocks_in(@space.downcase).map { |block|
            block.render(context.dup.merge('block' => block)) 
          }
        end
      end
    end

    Liquid::Template.register_tag('yield', Bop::Tags::Yield)
  end
end
