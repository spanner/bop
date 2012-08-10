class Bop::PlacedBlock < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :page
  belongs_to :block

  scope :in_bucket, lambda { |bucket|
  
  }

end
