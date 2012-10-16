module Bop
  class Engine < ::Rails::Engine
    isolate_namespace Bop
    initializer "bop.integration" do |config|
      ActiveRecord::Base.send(:include, Bop::Glue)
    end
    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w( bop.js bop.css bop_code.js bop_code.css )
    end
    
  end
end
