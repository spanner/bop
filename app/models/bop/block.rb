class Bop::Block < ActiveRecord::Base
  attr_accessible :title, :content, :type, :aset_id

  belongs_to :user
  belongs_to :asset
  has_many :block_properties
  has_many :placed_blocks
  has_many :pages, :through => :placed_blocks

  validate :title, :presence => true
  validate :content, :presence => true

  def block_type
    Bop::BlockType.get(read_attribute(:block_type))
  end
  
  def block_type=(block_type)
    block_type = Bop::BlockType.get(block_type) unless block_type.is_a? Bop::BlockType
    raise Bop::BlockTypeNotFound unless block_type
    write_attribute(:block_type, block_type) 
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
