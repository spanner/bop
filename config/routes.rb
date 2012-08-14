Bop::Engine.routes.draw do
  resources :pages
  resources :templates
  resources :blocks
  resources :block_properties
  resources :placed_blocks
  resource :publications
end

Rails.application.routes.draw do
  match '*path' => 'bop/pages#show_path', :as => :path, :defaults => {:format => 'html'}
end
