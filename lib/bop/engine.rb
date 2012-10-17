module Bop
  class Engine < ::Rails::Engine
    isolate_namespace Bop

    initializer "bop.integration" do
      ActiveRecord::Base.send(:include, Bop::Glue)
      ActiveRecord::Base.send :include, Bop::Helpers
    end

    initializer "bop.assets" do
      Rails.application.config.assets.precompile += %w( bop.js bop.css bop_code.js bop_code.css )
      Rails.application.config.assets.paths << "#{root}/vendor/assets/fonts"
    end
    
  end
end
