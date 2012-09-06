class Bop::Stylesheet < ActiveRecord::Base
  belongs_to :site
  
  def path
    "/bop/stylesheets/#{id}"
    # "something/#{slug}"
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
