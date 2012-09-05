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
  class SiteNotFound < BopError; end
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
    
    def site
      if scoped?
        scope.find_or_create_site
      else
        # subdomain match and other parameters could be applied here
        Bop::Site.find_or_create_by_name("Default")
      end
    end

    def root_page
      site.root_page
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

