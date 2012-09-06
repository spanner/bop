class Bop::Template < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :user
  has_many :pages

  def render_head(context)
    self.renderer(head).render(context)
  end
  
  def head_renderer
    @header ||= render_class.new.prepare(head)
  end

  def render_body(context)
    self.renderer(body).render(context)
  end

  def body_renderer
    @bodyer ||= render_class.new.prepare(body)
  end
  
  def render_class
    @render_class ||= Bop::Renderer.get(markup_type || 'liquid')
  end
end
