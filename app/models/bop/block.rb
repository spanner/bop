class Bop::Block < ActiveRecord::Base
  attr_accessible :title, :content, :type, :asset_id, :block_type_name, :asset_attributes

  belongs_to :user
  belongs_to :asset
  accepts_nested_attributes_for :asset
  has_many :block_properties
  has_many :placed_blocks
  has_many :pages, :through => :placed_blocks
    
  def block_type
    @block_type ||= Bop::BlockType.get(block_type_name || 'text')
  end
  
  def place_on_page(page, space)
    space ||= 'main'
    placed_blocks.create(:page => page, :space_name => space)
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
    self.renderer(block_template).render(block_context).html_safe
  end
  
  def as_json(options={})
    {
      :id => id,
      :content => content,
      :markup_type => markup_type,
      :block_type => block_type.name,
      :asset => asset.as_json(options)
    }
  end
  
  def to_liquid
    {
      'content' => content
    }
  end
    
end
