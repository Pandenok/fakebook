Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'posts#index'
  resources :friend_requests, only: [:create, :update, :destroy]
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :edit, :update, :destroy]
    member do
      delete :delete_image_attachment
    end
  end
  resources :users, only: [:index, :show, :edit, :update]
end
