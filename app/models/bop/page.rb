require 'ancestry'

class Bop::Page < ActiveRecord::Base
  @@renderable_fields = %w{title slug}
  cattr_accessor :renderable_fields
  attr_accessible :title, :slug, :template_id, :asset_id, :anchor, :site_id, :tree_id, :parent_id, :template

  belongs_to :site
  belongs_to :tree
  belongs_to :template
  belongs_to :user, :class_name => Bop.user_class
  belongs_to :asset
  has_ancestry :orphan_strategy => :destroy

  has_bop_blocks
  
  has_many :publications

  before_save :slugify_slug
  before_save :receive_context
  after_save :update_children

  # custom validators are defined in lib/bop/validators
  validates :slug, :local_slug_uniqueness => true, :presence_unless_root => true
  
  scope :other_than, lambda {|these|
    these = [these].flatten
    placeholders = these.map{"?"}.join(',')
    where(["NOT #{table_name}.id IN(#{placeholders})", *these.map(&:id)])
  }

  # Override the usual ancestry method so that siblings don't include self, because that's silly.
  def siblings
    self.base_class.other_than(self).scoped :conditions => sibling_conditions
  end

  def inherited_asset
    asset || parent && parent.inherited_asset
  end

  def renderable_field?(fieldname)
    self.class.renderable_fields.include?(fieldname)
  end
  
  def as_json(options={})
    {
      'id' => id,
      'title' => title
    }
  end
  
  
  
  
  
  ## Publishing
  #
  # Publications are frozen pages. 
  #
  
  def published?
    publications.any?
  end
  
  def publishable?
    updated_at > last_published_at
  end
  
  def last_published_at
    published_at || DateTime.new(0)
  end
  
  def latest
    publications.first
  end
  
  def root?
    !parent
  end
  
  def relative_route
    route.sub /^\//, ""
  end

private

  def update_context
    receive_context
    save!
  end
  
  def receive_context
    if root?
      self.slug = ""
      if tree.mount_point == "/"
        self.route = "/"
      else
        self.route = tree.mount_point + "/"
      end
      self.site = tree.site
    else
      self.title = slug unless title?
      self.tree = parent.tree
      self.site = parent.site
      ensure_presence_and_uniqueness_of(:slug, title.parameterize, self.siblings)
      descent = (ancestors + [self]).map(&:slug).compact.join('/')
      if tree.mount_point == "/"
        self.route = descent
      else
        self.route = tree.mount_point + descent
      end
    end
  end
  
  def slugify_slug
    self.slug = self.slug.parameterize if self.slug_changed?
  end

  def update_children
    self.class.transaction do
      children.each do |child|
        child.send :update_context
        child.save
      end
    end
  end

end

