require "liquid"

module Bop
  module Tags
    
    class Yield < Liquid::Tag
      def initialize(tag_name, space, tokens)
        super
        @space = space || "main"
      end

      def render(context)
        if page = Bop::Page.find(context["page"]["id"])
          output = ""
          page.blocks_for(@space.downcase).each do |block|
            output << block.render(context)
          end
          output
        end
      end
    end
    Liquid::Template.register_tag('yield', Bop::Tags::Yield)
  end
end
