module ActionDispatch::Routing

  class Mapper
    def bop
      bop_at('/')
    end

    def bop_at(prefix="/")
      prefix = "#{prefix}/" unless prefix.last == '/'
      mount Bop::Engine => "#{prefix}bop/", :as => :bop

      match "#{prefix}*path" => 'bop/publications#show', :as => :path, :defaults => {:format => 'html'}

      if prefix == '/'
        root :to => 'bop/publications#show', :as => :home, :defaults => {:format => 'html'}
      end
    end
  end
end
