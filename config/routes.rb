Rails.application.routes.draw do
   require 'sidekiq/web'
   mount Sidekiq::Web, at:'/sidekiq'

  devise_for :users

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end

  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
  end

  resources :reminders
  root to: 'reminders#index'

  # match '*path', :to => 'application#routing_error', :via => :all
end
