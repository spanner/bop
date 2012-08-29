require "liquid"

module Bop
  module Tags
    
    class Yield < Liquid::Tag
      def initialize(tag_name, space_name, tokens)
         super
         space_name = "main" if !space_name || space_name.blank?
         @space = space_name
      end

      def render(context)
        if page = Bop::Page.find(context["page"]["id"])
          Rails.logger.warn "!!  rendering space '#{@space}' for page #{page.inspect}"
          page.blocks_in(@space.downcase).each_with_object("") do |block, output|
            Rails.logger.warn "->  block #{block.inspect}"
            output << block.render(context)
          end
        end
      end
    end

    Liquid::Template.register_tag('yield', Bop::Tags::Yield)
  end
end
