module Bop
  class Tree < ActiveRecord::Base
    attr_accessible :name, :site_id, :mount_point
    
    belongs_to :site
    belongs_to :root_page, :class_name => "Bop::Page", :autosave => true
    has_many :pages
    after_save :ensure_root_page
    
  protected
  
    def ensure_root_page
      unless root_page
        self.root_page = pages.build(:title => "Root")
        self.save
      end
    end
  end
end
