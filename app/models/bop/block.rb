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
    Bop::BlockType.get(block_type_name)
  end
  
  def renderer(tpl)
    Bop::Renderer.get(markup_type || 'liquid').new.prepare(tpl)
  end

  def template(view="show")
    block_type.template(view)
  end

  def render(context, view="show")
    # set context so that the content of this block is available
    # use the renderer to render the template
    # yield content to the template with another custom tag
    block_template = template(view)
    block_context = context.dup.merge("block" => self)
    self.renderer(block_template).render(context)
  end
  
  def to_liquid
    {
      'title' => title,
      'content' => content
    }
  end
end
