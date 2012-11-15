class Bop::Publication < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  belongs_to :site
  default_scope order("created_at DESC")

  after_create :become_public

  validate :title , :presence => true
  validate :rendered_body, :presence => true

  scope :active, where("active = 1")

  scope :other_than, lambda {|these|
    these = [these].flatten
    placeholders = these.map{"?"}.join(',')
    where(["NOT publications.id IN(#{placeholders})", *these.map(&:id)])
  }

  def activate!
    page.publications.other_than(self).map(&:deactivate!)
    update_column(:active => true)
  end
  
  def deactivate!
    update_column(:active => false)
  end

protected

  # We inherit the page route and use that for routing responses in the public site,
  # so that changes to the page slug don't cause routing changes until they are published.
  # Also has the benefit that the whole public site can be delivered without retrieving
  # any page objects.
  #
  def become_public
    page.touch(:published_at)
    activate!
  end
  
end
