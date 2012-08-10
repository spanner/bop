module Bop
  class Engine < ::Rails::Engine
    isolate_namespace Bop
    initializer "bop.integration" do
      ActiveRecord::Base.send(:include, Bop::Glue)
    end
  end
end
