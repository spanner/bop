module Bop
  class AssetsGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../../app/assets/', __FILE__)
    
    def copy_font_directory
      directory "fonts/", Rails.root + "public/fonts/"
    end
        
  end
end