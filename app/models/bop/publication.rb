class Bop::Publication < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  default_scope order("created_at DESC")
  before_validation :clone_page
  after_save :notify_page

  validate :title , :presence => true
  validate :rendered_body, :presence => true
  
protected

  def clone_page
    self.title = page.title
    self.rendered_head = page.head
    self.rendered_body = page.body
  end
  
  def notify_page
    page.touch(:published_at)
  end
end
