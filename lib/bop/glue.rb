module Bop
  module Glue
    def self.included(base)
      base.extend Bop::BoppableClassMethods
      base.send :include, Bop::BoppableInstanceMethods
    end
  end
end
