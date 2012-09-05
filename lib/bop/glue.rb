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
        has_one :site, :class_name => "Bop::Site", :as => "anchor"
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
  
end
