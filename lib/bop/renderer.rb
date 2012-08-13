# At the moment block types are just parameterised template-finders.
#

module Bop
  class Renderer
    attr_reader :name

    def initialize
      @renderer = nil
    end
  
    def prepare(template)
      @template = template
    end
  
    def render(context)
      # do what?
    end
  
    class << self
      def renderers
        @renderers ||= {}
      end
      
      def register(name, klass)
        renderers[name] = klass
      end
      
      def get(name)
        renderers[name]
      end
      def [](name)
        get(name)
      end
    end
  end
  
  require "liquid"

  class LiquidRenderer < Bop::Renderer
    def prepare(template)
      @template = Liquid::Template.parse(template)
    end

    def render(context)
      @template.render(context)
    end
    
    Renderer.register 'liquid', self
  end


  class SimpleRenderer < Bop::Renderer
    include ActionView::Helpers::TextHelper
    
    def prepare(template)
      @template = template
    end
  
    def render(context)
      simple_format(@template)
    end
    
    Renderer.register 'simple', self
  end

end