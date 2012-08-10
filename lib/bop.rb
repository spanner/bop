require "bop/engine"
require "bop/tags"
require "bop/glue"
require "bop/block_type"
require "bop/renderer"

module Bop
  class BopError < StandardError; end
  class MissingRootPageError < BopError; end
  class MissingPageError < BopError; end
  class MissingTemplateError < BopError; end

  module ClassMethods
    def has_pages
      include InstanceMethods
      has_many :pages, :class_name => "Bop::Page", :as => "anchor"
      after_save :ensure_root_page
    end
  end

  module InstanceMethods
    def root_page!
      raise Bop::MissingRootPageError unless page = root_page
      page
    end

    def root_page
      find_page("")
    end

    def find_page!(route)
      raise Bop::MissingPageError unless page = find_page(route)
      page
    end

    def find_page(route)
      pages.find_by_route(route)
    end

  protected
    
    def ensure_root_page
      unless root_page
        pages.create(:title => "Home", :slug => "")
      end
    end
  
  end
end

