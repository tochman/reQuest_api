# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth'
  namespace :api do
    resources :offers, only: [:create]
    resources :karma_points, only: [:index], constraints: { format: 'json' }
    resources :requests, only: %i[index], constraints: { format: 'json' }
    namespace :my_request do
      resources :requests, only: [:create, :update], constraints: { format: 'json' }
    end
  end
end
