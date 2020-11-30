Rails.application.routes.draw do
  devise_for :users
  root to: 'static#index'
  resource :friend_requests, only: [:create, :update, :destroy]
end
