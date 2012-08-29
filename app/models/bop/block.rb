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
    @block_type ||= Bop::BlockType.get(block_type_name)
  end
  
  def renderer(tpl)
    Bop::Renderer.get(markup_type || 'liquid').new.prepare(tpl)
  end

  def template(view="show")
    block_type.template(view)
  end

  def render(context, view="show")
    block_template = template(view)
    block_context = context.dup.merge("block" => self)
    self.renderer(block_template).render(block_context)
  end
  
  def to_liquid
    {
      'title' => title,
      'content' => content
    }
  end
end
