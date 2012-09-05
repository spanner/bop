module Bop
  module Glue
    def included(base)
      base.extend BoppableClassMethods
    end
  
    module BoppableClassMethods
      def has_pages?
        false
      end
      
      def has_pages(options={})
        include BoppedInstanceMethods
        extend BoppedClassMethods
        has_many :pages, :class_name => "Bop::Page", :as => "anchor"
        after_save :ensure_root_page
        @owner_class = options[:belonging_to]
      end
    end

    module BoppedClassMethods
      def has_pages?
        true
      end
      
      def owner_class
        @owner_class
      end
    end

    module BoppedInstanceMethods

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
  
end
