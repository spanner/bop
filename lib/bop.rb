require "bop/engine"
require "bop/routing"
require "bop/helpers"
require "bop/liquid_tags"
require "bop/glue"
require "bop/block_type"
require "bop/renderer"
require "bop/validators"

module Bop
  mattr_accessor :layout, :editor_layout, :dashboard_layout, :editable_head
  @@scope ||= nil
  
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
    
    def editable_head
      !!@@editable_head
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
  #
  module BoppableClassMethods
    def has_bop_pages?
      false
    end

    def has_bop_blocks?
      false
    end
    
    def has_bop_pages(options={})
      include PagedInstanceMethods
      extend PagedClassMethods
      has_one :site, :class_name => "Bop::Site", :as => :anchor
    end

    def has_bop_blocks(options={})
      include BlockedInstanceMethods
      extend BlockedClassMethods
      has_many :placements, :class_name => "Bop::Placement", :as => :place
      has_many :items, :through => :placements
    end
  end
  

  # These class and instance methods are included into model classes where `has_bop_pages` is called.
  # They provide the connection between objects of that class and the site associated with each.
  # Each site will have one or more trees, and each tree with have a number of pages.
  #
  module PagedClassMethods
    def has_bop_pages?
      true
    end
  end

  module PagedInstanceMethods
    def find_or_create_site
      self.site ||= self.create_site
    end

    def root_page
      find_or_create_site.find_page("/")
    end

    def find_page(route)
      find_or_create_site.find_page(route)
    end

    def find_publication(route)
      find_or_create_site.find_publication(route)
    end
  end

  # These class and instance methods are included into model classes where `has_bop_blocks` is called.
  # They provide the mechanisms for retrieving and rendering blocks.
  #
  module BlockedClassMethods
    def has_bop_blocks?
      true
    end
  end

  module BlockedInstanceMethods
    def items_in(space="main")
      placements.in_space(space).map(&:item).compact
    end

    def render_space(space)
      Rails.logger.warn ">>> rendering space #{space} on page #{self.inspect}. Items: #{items_in(space).inspect}"
      output = items_in(space).each_with_object(''.html_safe) do |item, op|
        Rails.logger.warn ">>> rendering item #{item.inspect}"
        op << item.render(context)
      end
      #todo: I hate having this content_tag here. Put it in a haml template somewhere.
      content_tag :section, output, :class => 'space', :"data-bop-space" => @space
    end
  end
end

