class Bop::Block < ActiveRecord::Base
  attr_accessible :title, :content, :type

  belongs_to :user
  has_many :block_properties
  has_many :placed_blocks
  has_many :pages, :through => :placed_blocks

  def block_type
    Bop::BlockType.get(type)
  end
  
  def renderer
    Bop::Renderer.get(markup_type || 'liquid')
  end

  def template(view="show")
    block_type.template(view)
  end

  def render(context, view="show")
    template(view).render(context)
  end
end
