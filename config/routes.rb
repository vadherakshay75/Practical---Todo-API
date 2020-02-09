# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :sessions, :users
  resources :todos do
    resources :items, except: %i[show index]
  end
  match '*path', to: 'application#rescue_404', via: [:all]
end
