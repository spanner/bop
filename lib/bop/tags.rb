require "liquid"

module Bop
  module Tags
    
    class Yield < Liquid::Tag
      def initialize(tag_name, bucket, tokens)
         super
         @bucket = bucket || "main"
      end

      def render(context)
        if page = context[:page]
          block_context = context.dup.merge(:block => self)
          page.blocks_for(@bucket.downcase).map{ |block| block.render(block_context) }
        end
      end
    end

    Liquid::Template.register_tag('yield', Bop::Tags::Yield)
  end
end