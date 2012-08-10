# At the moment block types are just parameterised template-finders.
#

class Bop::BlockType
  @@types = []
  @@type_lookup = {}
  @template = {}
  attr_reader :name

  def initialize(name, options = {})
    options = options.symbolize_keys
    @name = name
    @@types.push self
    @@type_lookup[@name] = self
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
      raise Bop::MissingTemplateError unless tpl
      @templates[name] = Liquid::Template.parse(tpl)
    end
    @templates[name]
  end
end

def self.find(type)
  @@type_lookup[type] if type
end

def self.[](type)
  find(type)
end
