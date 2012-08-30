Bop::Engine.routes.draw do
  resources :pages do
    post "publish", :on => :member, :as => :publish
    get "revert", :on => :member, :as => :revert
  end
  resources :templates
  resources :blocks
  resources :block_properties
  resources :placed_blocks
  resources :publications
  
  match "*path" => 'pages#show', :as => :unpublished, :defaults => {:format => 'html'}
end
