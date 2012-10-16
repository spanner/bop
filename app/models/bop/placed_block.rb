class Bop::PlacedBlock < ActiveRecord::Base
  attr_accessible :page, :position, :block, :space_name

  belongs_to :place, :polymorphic => true
  belongs_to :block

  default_scope order('position')
  
end
