class Bop::Block < ActiveRecord::Base
  attr_accessible :title, :content, :type, :aset_id

  belongs_to :user
  belongs_to :asset
  has_many :block_properties
  has_many :placed_blocks
  has_many :pages, :through => :placed_blocks

  validate :title, :presence => true
  validate :content, :presence => true

  # only works when appended to page.blocks (to bring in the joining table)
  scope :in_space, lambda { |space|
    where(["bop_placed_blocks.space_name = ?", space])
  }
  
  def block_type
    Bop::BlockType.get(type)
  end
  
  def renderer
    Bop::Renderer.get(markup_type || 'liquid').prepare(content)
  end

  def template(view="show")
    block_type.template(view)
  end

  def render(context, view="show")
    template(view).render(context)
  end
end
