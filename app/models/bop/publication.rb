class Bop::Publication < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  before_create :render_page

protected

  def render_page
    self.rendered_content = page.render()
  end

end
