Rails.application.routes.draw do
  resources :items, only: [:index]
  resources :orders, only: [:create, :show] do
    member do
      post :pay
    end
  end
end
