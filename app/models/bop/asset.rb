class Bop::Asset < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :blocks
  
  has_attached_file :file
  
  def as_json(options={})
    {
      :id => id
    }
  end
  
end
