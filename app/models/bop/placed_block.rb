class Bop::PlacedBlock < ActiveRecord::Base
  attr_accessible :page, :block, :space_name

  belongs_to :page
  belongs_to :block

end
