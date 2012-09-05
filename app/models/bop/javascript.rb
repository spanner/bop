class Bop::Javascript < ActiveRecord::Base
  belongs_to :site
  
  
  
  def as_json(options={})
    {
      :id => id,
      :title => title,
      :content => content
    }
  end
  
  def to_liquid
    {
      'title' => title,
      'content' => content
    }
  end
  
end

