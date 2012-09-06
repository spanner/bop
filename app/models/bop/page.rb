require 'ancestry'

class Bop::Page < ActiveRecord::Base
  attr_accessible :title, :slug, :template_id, :asset_id, :anchor, :site_id, :tree_id, :parent_id

  belongs_to :site
  belongs_to :tree
  belongs_to :template
  belongs_to :user
  belongs_to :asset
  has_ancestry :orphan_strategy => :destroy
  has_many :placed_blocks
  has_many :blocks, :through => :placed_blocks
  has_many :publications

  before_save :receive_context
  before_save :slugify_slug
  after_save :update_children

  # custom validators are defined in lib/bop/validators
  validates :slug, :local_slug_uniqueness => true, :presence_unless_root => true
  
  scope :other_than, lambda {|these|
    these = [these].flatten
    placeholders = these.map{"?"}.join(',')
    where(["NOT #{table_name}.id IN(#{placeholders})", *these.map(&:id)])
  }

  def blocks_in(space="main")
    # the :through association to blocks already joins to bop_placed_blocks 
    # so we can add a condition on that table. It's a bit fragile but it works.
    blocks.where(["bop_placed_blocks.space_name = ?", space])
  end

  # Override the usual ancestry method so that siblings don't include self, because that's silly.
  def siblings
    self.base_class.other_than(self).scoped :conditions => sibling_conditions
  end

  def find_template
    template || (parent && parent.find_template) || Bop::Template.find_or_create_by_title_and_content("Default","<h1>{{page.title}}</h1>{% yield %}")
  end

  def inherited_asset
    asset || parent && parent.inherited_asset
  end
  
  def place_block(block, space)
    placed_block = placed_blocks.find_or_create_by_block_id(block.id, :space_name => space)
  end


  ## Rendering
  #
  # is handled by the template. We supply this page object as part of its context and presume that the template
  # contains page-related tags.
  #
  def head(additional_context={})
    find_template.render(:head, context.merge(additional_context))
  end

  def body(additional_context={})
    find_template.render(:body, context.merge(additional_context))
  end
  
  def blocks_for(space)
    blocks.in_space(space)
  end
  
  def context
    @context ||= {
      'page' => self,
      'site' => site,
      'asset' => inherited_asset
    }
  end
  
  def to_liquid
    as_json()
  end
  
  
  
  
  
  def as_json(options={})
    {
      'id' => id,
      'title' => title
    }
  end
  
  def publish!
    publications.create
  end
  
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
      self.route = tree.mount_point + "/"
      self.site = tree.site
    else
      self.title = slug unless title?
      self.tree = parent.tree
      self.site = parent.site
      ensure_presence_and_uniqueness_of(:slug, title.parameterize, self.siblings)
      descent = (ancestors + [self]).map(&:slug).compact.join('/')
      self.route = tree.mount_point + descent
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

