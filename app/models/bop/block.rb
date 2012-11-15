class Bop::Block < ActiveRecord::Base
  attr_accessible :title, :content, :type, :asset_id, :asset_attributes

  belongs_to :user, :class_name => Bop.user_class
  belongs_to :asset
  
  accepts_nested_attributes_for :asset
  has_many :placements, :as => :item
  has_many :pages, :through => :placements
  accepts_nested_attributes_for :placements, :allow_destroy => true
  
  def place_on_page(page, space)
    space ||= 'main'
    placements.create(:page => page, :space_name => space)
  end
  
  def render
    content
  end

  def as_json(options={})
    {
      :id => id,
      :content => content,
      :markup_type => markup_type,
      :asset => asset.as_json(options)
    }
  end
end
