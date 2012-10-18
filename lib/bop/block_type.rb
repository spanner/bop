# At the moment block types are just parameterised template-finders.
#

module Bop
  class BlockType
    attr_reader :name
    
    def to_s
      name
    end

    def initialize(name, options = {})
      options = options.symbolize_keys
      @name = name
      self.class.register name, self
    end
  
    def template(view)
      @templates ||= {}
      unless @templates[view]
        # Here we will need to support various file types and should probably just hook into ActionView. That's going to be fun.
        tpl = nil
        [Rails.root, Bop::Engine.root].each do |root|
          if !tpl && File.exist?(root + "app/views/bop/block_types/#{name}/#{view}.liquid")
            tpl = File.read(root + "app/views/bop/block_types/#{name}/#{view}.liquid")
          end
        end
        raise Bop::TemplateNotFound unless @templates[name] = tpl
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