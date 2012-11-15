class Bop::Placement < ActiveRecord::Base
  attr_accessible :page, :position, :block, :space_name

  belongs_to :place, :polymorphic => true
  belongs_to :item, :polymorphic => true

  default_scope order('position')
  
  scope :in_space, lambda { |space|
    where(["space_name = ?", space]).includes(:item)
  }
  
  def render
    item.render
  end
  
end
