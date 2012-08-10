class Bop::Publication < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  before_create :render_page

protected

  def render_page
    self.content = page.render()
  end

end
