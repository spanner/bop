module Bop
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    
    def copy_initializer_file
      copy_file "bop_initializer.rb", Rails.root + "config/initializers/bop.rb"
    end
    
    def rake_db
      rake("bop:install:migrations")
      rake("db:migrate")
    end
    
  end
end