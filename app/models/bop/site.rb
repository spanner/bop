module Bop
  class Site < ActiveRecord::Base
    attr_accessible :name, :slug, :anchor

    belongs_to :anchor, :polymorphic => true
    has_many :trees
    has_many :publications
    has_many :pages
    has_many :javascripts
    has_many :stylesheets
    has_many :templates
    
    before_create :ensure_primary_tree
    
    def primary_tree
      trees.find_by_mount_point('/')
    end
    
    def root_page
      primary_tree.root_page
    end
        
    def find_publication(path)
      publications.active.find_by_route(path)
    end

    def find_page(path)
      pages.find_by_route(path)
    end
    
    def build_page(attributes)
      pages.build(attributes)
    end

    def create_page(attributes)
      pages.create(attributes)
    end
    
  protected
  
    def ensure_primary_tree
      trees.build(:mount_point => '/') unless primary_tree
    end
    
  end
end
