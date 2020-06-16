# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth'
  namespace :api do
    resources :karma_points, only: [:show], constraints: { format: 'json' }
    resources :requests, only: %i[create index], constraints: { format: 'json' }
  end
end
