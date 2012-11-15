Bop::Engine.routes.draw do
  resources :publications, :only => [:show, :index]

  resources :javascripts
  resources :stylesheets
  resources :templates
  resources :assets
  resources :users
  resources :pages do
    resources :blocks
    resources :placed_blocks
    resources :publications
  end
  
  match "/" => 'pages#index', :as => :dashboard, :defaults => {:format => 'html'}
  match "/css/:slug.:format" => 'stylesheets#show', :as => :css, :defaults => {:format => 'css'}
  match "/js/:slug.:format" => 'javascripts#show', :as => :js, :defaults => {:format => 'js'}
  match "*path" => 'pages#show', :as => :unpublished, :defaults => {:format => 'html'}
end
