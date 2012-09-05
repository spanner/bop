module Bop
  module Glue
    def self.included(base)
      base.extend Bop::BoppableClassMethods
    end
  end
end
