require "liquid"

module Bop
  module Tags
    
    class Yield < Liquid::Tag
      def initialize(tag_name, space, tokens)
         super
         @space = space || "main"
      end

      def render(context)
        if page = context[:page]
          block_context = context.dup.merge(:block => self)
          output = ""
          page.blocks_for(@space.downcase).each do |block|
            output << block.render(block_context)
          end
          output
        end
      end
    end

    Liquid::Template.register_tag('yield', Bop::Tags::Yield)
  end
end
