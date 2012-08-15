Bop::Engine.routes.draw do
  resources :pages do
    get "publish", :on => :member, :as => :publish
    get "revert", :on => :member, :as => :revert
  end
  resources :templates
  resources :blocks
  resources :block_properties
  resources :placed_blocks
  resource :publications
end

Rails.application.routes.draw do
  match '*path' => 'bop/publications#show', :as => :path, :defaults => {:format => 'html'}
end
