# At the moment block types are just parameterised template-finders.
#

module Bop
  class BlockType
    attr_reader :name

    def initialize(name, options = {})
      options = options.symbolize_keys
      @name = name
      self.class.register name, self
    end
  
    def template(name)
      unless @templates[name]
        # Here we will need to support various file types and should probably just hook into ActionView. That's going to be fun.
        tpl = null
        [Bop::Engine.root, Rails.root].each do |root|
          if !tpl && File.exist(root + "app/views/bop/block_types/#{name}.liquid")
            tpl = File.read(root + "app/views/bop/block_types/#{name}.liquid")
          end
        end
        raise Bop::MissingTemplateError unless @templates[name] = tpl
      end
      @templates[name]
    end
    
    class << self
      def block_types
        @block_types ||= {}
      end
      
      def register(name, instance)
        block_types[name] = instance
      end
      
      def get(name)
        block_types[name]
      end
      def [](name)
        get(name)
      end
    end
  end
end