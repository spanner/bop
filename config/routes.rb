Bop::Engine.routes.draw do
  resources :pages do
    get "publish", :on => :member, :as => :publish
    get "revert", :on => :member, :as => :revert
  end
  resources :templates
  resources :blocks
  resources :block_properties
  resources :placed_blocks
  resources :publications
  
  match "*path" => 'pages#show', :as => :current, :defaults => {:format => 'html'}
end
