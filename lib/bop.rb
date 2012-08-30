require "bop/engine"
require "bop/routing"
require "bop/tags"
require "bop/glue"
require "bop/block_type"
require "bop/renderer"
require "bop/validators"

module Bop
  class BopError < StandardError; end
  class RootPageNotFound < BopError; end
  class PageNotFound < BopError; end
  class TemplateNotFound < BopError; end
  class MarkupNotFound < BopError; end
  class BlockTypeNotFound < BopError; end
  
  mattr_accessor :scope

  module ClassMethods
    def has_pages
      include InstanceMethods
      has_many :pages, :class_name => "Bop::Page", :as => "anchor"
      after_save :ensure_root_page
    end
  end

  module InstanceMethods

    def root_page
      find_page("/")
    end
    
    def find_page(route)
      pages.find_by_route(route)
    end

  protected
    
    def ensure_root_page
      unless root_page
        root = pages.create(:title => "Home", :slug => "", :anchor => self)
      end
    end
  
  end
end

