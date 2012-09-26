class Bop::Template < ActiveRecord::Base
  attr_accessible :title, :body, :head

  belongs_to :user
  has_many :pages
    
  def render(part=:body, context)
    renderer(part).render(context)
  end

  def renderer(part)
    render_class.new.prepare(send part)
  end
  
  def render_class
    @render_class ||= Bop::Renderer.get(markup_type || 'liquid')
  end
end
