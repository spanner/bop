class Bop::Javascript < ActiveRecord::Base
  belongs_to :site

  def path
    # for now
    "/bop/javascripts/#{id}"
    
    # eventually "something/#{slug}"
  end
    
  def as_json(options={})
    {
      :id => id,
      :title => title,
      :content => content
    }
  end
  
  def to_liquid
    {
      'slug' => title,
      'content' => content
    }
  end
  
end

