Bop::Engine.routes.draw do
  resources :publications, :only => [:show, :index]

  resources :javascripts
  resources :stylesheets
  resources :templates
  resources :pages do
    resources :blocks
    resources :publications
    
    # These will go soon in favour of publication crud
    post "publish", :on => :member, :as => :publish
    get "revert", :on => :member, :as => :revert
  end
  
  match "/" => 'pages#index', :as => :dashboard, :defaults => {:format => 'html'}
  match "/css/:slug.:format" => 'stylesheets#show', :as => :css, :defaults => {:format => 'css'}
  match "/js/:slug.:format" => 'javascripts#show', :as => :js, :defaults => {:format => 'js'}
  match "*path" => 'pages#show', :as => :unpublished, :defaults => {:format => 'html'}
end
