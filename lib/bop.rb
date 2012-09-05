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



  # These class methods are included into ActiveRecord::Base and so available in all model classes.

  module BoppableClassMethods
    def has_pages?
      false
    end
    
    def has_pages(options={})
      include BoppedInstanceMethods
      extend BoppedClassMethods
      has_one :site, :class_name => "Bop::Site", :as => "anchor"
      @owner_class = options[:belonging_to]
    end
  end

  # These class and instance methods are included into specific model classes when has_pages is called.

  module BoppedClassMethods
    def has_pages?
      true
    end
    
    def owner_class
      @owner_class
    end
  end

  module BoppedInstanceMethods

    def find_or_create_site
      site ||= create_site
    end

    def root_page
      find_or_create_site.find_page("/")
    end

    def find_page(route)
      find_or_create_site.find_page(route)
    end

  end

end

