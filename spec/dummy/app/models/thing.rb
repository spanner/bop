class Thing < ActiveRecord::Base
  attr_accessible :title
  has_pages
  
  def to_liquid
    {
      'title' => title
    }
  end
end
