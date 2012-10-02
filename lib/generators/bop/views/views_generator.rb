module Bop
  class ViewsGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../app/views/bop', __FILE__)
  
    def copy_views
      directory "", Rails.root + "app/views/"
    end
  end
end