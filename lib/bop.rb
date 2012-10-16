require "bop/engine"
require "bop/routing"
require "bop/tags"
require "bop/glue"
require "bop/block_type"
require "bop/renderer"
require "bop/validators"

module Bop
  mattr_accessor :layout, :editor_layout, :dashboard_layout
  
  class BopError < StandardError; end
  class ConfigurationError < BopError; end
  class SiteNotFound < BopError; end
  class RootPageNotFound < BopError; end
  class PageNotFound < BopError; end
  class AdminNotFound < BopError; end
  class TemplateNotFound < BopError; end
  class MarkupNotFound < BopError; end
  class BlockTypeNotFound < BopError; end
  
  
  ## Configuration
  #
  # These settings are structural and usually set from an initializer in the host app.
  #
  class << self
    def user_class=(klass)
      @@user_class = klass.to_s
    end
    
    def user_class
      (@@user_class ||= "User").constantize
    end

    def layout
      @@layout ||= 'bop/wrapper'
    end
    
    def editor_layout
      @@editor_layout ||= 'bop/editor'
    end
    
    def dashboard_layout
      @@dashboard_layout ||= 'bop/dashboard'
    end
    
    def scope
      @@scope
    end
    
    def scope=(instance)
      raise Bop::ConfigurationError unless instance.class.has_pages?
      @@scope = instance
    end
    
    def scoped?
      !!scope
    end
    
    def site=(site)
      @@site = site
    end
    
    def site
      @@site ||= if scoped?
        scope.find_or_create_site
      else
        Bop::Site.find_or_create_by_name("Default")
      end
    end
    
    def root_page
      site.root_page
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
    end
  end
  
  module BoppableInstanceMethods
    def ensure_presence_and_uniqueness_of(column, base, scope=self.class.scoped)
      unless self.send :"#{column}?"
        value = base
        addendum = 0
        value = "#{base}_#{addendum+=1}" while scope.send :"find_by_#{column}", value
        self.send :"#{column}=", value
      end
    end
  end

  # These class and instance methods are included into specific model classes when has_pages is called.

  module BoppedClassMethods
    def has_pages?
      true
    end
  end

  module BoppedInstanceMethods

    def find_or_create_site
      self.site ||= self.create_site
    end

    def root_page
      find_or_create_site.find_page("/")
    end

    def find_page(route)
      find_or_create_site.find_page(route)
    end

  end

end

