require 'ancestry'

class Bop::Page < ActiveRecord::Base
  attr_accessible :title, :slug, :template_id, :race_id, :asset_id, :anchor

  belongs_to :anchor, :polymorphic => true
  belongs_to :template
  belongs_to :user
  belongs_to :asset
  has_ancestry :orphan_strategy => :destroy
  has_many :placed_blocks
  has_many :blocks, :through => :placed_blocks
  has_many :publications

  before_save :receive_context
  after_save :update_children

  # local_slug_uniqueness is a custom validator defined in lib/bop
  validates :slug, :local_slug_uniqueness => true, :presence_unless_root => true
  validates :title, :presence => true
  
  scope :other_than, lambda {|these|
    these = [these].flatten
    placeholders = these.map{"?"}.join(',')
    where(["NOT #{self.table_name}.id IN(#{placeholders})", *these.map(&:id)])
  }

  # Override the standard ancestry method so that siblings don't include self.
  def siblings
    self.base_class.other_than(self).scoped :conditions => sibling_conditions
  end

  def inherited_template
    template || parent && parent.inherited_template
  end

  def inherited_asset
    asset || parent && parent.inherited_asset
  end

  def render(additional_context={})
    inherited_template.render(context.merge(additional_context))
  end
  
  def context
    @context ||= {
      'page' => self,
      'asset' => inherited_asset,
      anchor.class.to_s.underscore => anchor
    }
  end
  
  def to_liquid
    as_json()
  end
  
  def as_json(options={})
    {
      'title' => title
    }
  end
  
  def publish!
    publications.create(:rendered_content => self.render)
  end
  
  def published?
    publications.any?
  end
  
  def latest
    publications.first
  end
  
  def root?
    !parent
  end

private
  def update_context
    receive_context
    save!
  end
  
  def receive_context
    if root?
      self.slug = ""
      self.route = "/"
    else
      self.slug ||= title.parameterize
      self.anchor = parent.anchor
      self.route = (ancestors + [self]).map(&:slug).join('/')
    end
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

