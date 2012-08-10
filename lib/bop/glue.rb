module Bop
  module Glue
    def self.included base #:nodoc:
      base.extend ClassMethods
    end
  end
end
