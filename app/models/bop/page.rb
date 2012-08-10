require 'ancestry'

class Bop::Page < ActiveRecord::Base
  attr_accessible :title, :slug, :template_id, :race_id, :asset_id

  belongs_to :anchor, :polymorphic => true
  belongs_to :race
  belongs_to :template
  belongs_to :user
  belongs_to :asset
  has_ancestry :orphan_strategy => :destroy
  has_many :placed_blocks
  has_many :blocks, :through => :placed_blocks
  has_many :publications

  before_save :ensure_slug
  before_save :receive_context
  after_save :contextualize_children

  validate :title, :presence => true
  # this needs scoping
  validate :slug, :uniqueness => true, :presence => true

  def inherited_template
    template || parent && parent.inherited_template
  end

  def inherited_asset
    asset || parent && parent.inherited_asset
  end

  def render(additional_context={})
    inherited_template.render(context.merge(additional_context))
  end
  
  # Fixed
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
  
  def publish
    publications.create
  end
  
  def published?
    publications.any?
  end
  
  def latest
    publications.first
  end

protected

  def ensure_slug
    self.slug ||= title.parameterize
  end

  def receive_context
    if parent
      self.anchor = parent.anchor
      self.route = (ancestors + [self]).map(&:slug).join('/')
    else
      self.route = ""
    end
  end

  def contextualize_children
    children.each do |child|
      child.receive_context
      child.save
    end
  end

end
