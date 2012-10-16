module Droom
  module Helpers
    def self.included(base)
      base.extend Droom::ClassMethods
      base.send :include, Droom::InstanceMethods
    end
  end
  
  module ClassMethods

  end
  
  module InstanceMethods

    def ensure_presence_and_uniqueness_of(column, base, scope=self.class.scoped)
      unless self.send :"#{column}?"
        value = base
        addendum = 0
        value = "#{base}_#{addendum+=1}" while scope.send :"find_by_#{column}", value
        self.send :"#{column}=", value
      end
    end
    
  end
end
