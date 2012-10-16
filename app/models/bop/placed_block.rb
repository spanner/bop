class Bop::PlacedBlock < ActiveRecord::Base
  attr_accessible :page, :position, :block, :space_name

  belongs_to :page
  belongs_to :block

  default_scope order('position')
  
end
