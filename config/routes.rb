Bop::Engine.routes.draw do
  resources :publications, :only => [:show, :index]

  resources :javascripts
  resources :stylesheets
  resources :pages do
    resources :blocks
    resources :publications
  resources :templates
    
    # These will go soon in favour of publication crud
    post "publish", :on => :member, :as => :publish
    get "revert", :on => :member, :as => :revert
  end
  
  # match "*path" => 'pages#show', :as => :unpublished, :defaults => {:format => 'html'}
end
