require 'ancestry'

class Bop::Page < ActiveRecord::Base
  attr_accessible :title, :slug, :template_id, :race_id, :asset_id

  belongs_to :race
  belongs_to :template
  belongs_to :user
  belongs_to :asset
  has_ancestry :orphan_strategy => :destroy
  has_many :placed_blocks
  has_many :blocks, :through => :placed_blocks

  before_save :ensure_slug
  before_save :receive_context
  after_save :propagate_context

  validate :title, :presence => true
  # this needs scoping
  validate :slug, :uniqueness => true, :presence => true

  def inherited_template
    template || parent.inherited_template
  end

  def inherited_asset
    asset || parent.inherited_asset
  end

  # currently we only support liquid for page layouts
  def render
    inherited_template.compiled.render(context)
  end
  
  # Fixed
  def context
    @context ||= {
      :page => self,
      :asset => inherited_asset,
      :race => race,
      :user => User.current,
      :account => Account.current
    }
  end

protected

  def ensure_slug
    self.slug ||= title.parameterize
  end

  def receive_context
    if parent
      self.race = parent.race
      self.route = (ancestors + [self]).map(&:slug).join('/')
    else
      self.route = ""
    end
  end

  def propagate_context
    children.each do |child|
      child.receive_context
      child.save
    end
  end

end
