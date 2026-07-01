Rails.application.routes.draw do
  root "home#index"

  resources :sites
  resources :learning_objects
  resources :structures
end
