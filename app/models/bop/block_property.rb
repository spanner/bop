class Bop::BlockProperty < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :block
end
