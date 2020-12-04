Rails.application.routes.draw do
  devise_for :users
  root to: 'static#index'
  resources :friend_requests, only: [:create, :update, :destroy]
  resources :posts do
    resources :likes, only: [:create, :destroy]
  end
end
