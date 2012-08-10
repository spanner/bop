class Bop::Template < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :user
  has_many :pages

  def render(context)
    self.renderer.render(context)
  end

  def renderer
    @renderer ||= render_class.new.prepare(content)
  end
  
  def render_class
    @render_class ||= Bop::Renderer.get(markup_type || 'liquid')
  end
end
