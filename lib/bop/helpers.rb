module Bop
  module Helpers
    
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
