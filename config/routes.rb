Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'
  resources :friend_requests, only: [:create, :update, :destroy]
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
end
