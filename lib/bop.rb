require "bop/engine"
require "bop/routing"
require "bop/tags"
require "bop/glue"
require "bop/block_type"
require "bop/renderer"
require "bop/validators"

module Bop
  class BopError < StandardError; end
  class ConfigurationError < BopError; end
  class RootPageNotFound < BopError; end
  class PageNotFound < BopError; end
  class AdminNotFound < BopError; end
  class TemplateNotFound < BopError; end
  class MarkupNotFound < BopError; end
  class BlockTypeNotFound < BopError; end
  
  class << self
    def scope
      @scope
    end
    
    def scope=(instance)
      raise Bop::ConfigurationError unless instance.class.has_pages?
      @scope = instance
    end
    
    def scoped?
      !!scope
    end
  
    def pages
      if scoped?
        scope.pages
      else
        Bop::Page.scoped
      end
    end
  
    def root_page
      @root ||= find_page("/") || create_page(:title => "Home")
    end
  
    def find_page(path)
      pages.find_by_route(path)
    end
    
    def build_page(attributes)
      if scoped?
        pages.build(attributes)
      else
        Bop::Page.new(attributes)
      end
    end

    def create_page(attributes)
      if scoped?
        pages.create(attributes)
      else
        Bop::Page.create(attributes)
      end
    end

    def owner_class
      if scoped?
        @owner_class ||= scope.class.owner_class || "User".constantize
      else
        @owner_class ||= "User".constantize
      end
    end

    def owner_class=(klassname)
      @owner_class = klassname.constantize
    end
  end

end

