class Bop::Javascript < ActiveRecord::Base
  attr_accessible :title, :slug, :content
  
  belongs_to :site
  before_save :ensure_slug
  validate :slug, :presence => true, :uniqueness => true
  before_validation :ensure_slug

  scope :other_than, lambda { |this|
    where(["not #{table_name}.id = ?", this.id]) unless this.new_record?
  }

  def path
    "/bop/javascripts/#{slug}.js"
  end
    
  def as_json(options={})
    {
      :id => id,
      :title => title,
      :content => content,
      :slug => slug
    }
  end
  
  def to_liquid
    {
      'slug' => slug,
      'content' => content
    }
  end

protected

  def ensure_slug
    ensure_presence_and_uniqueness_of(:slug, title.parameterize, self.site.javascripts.other_than(self))
  end

end

