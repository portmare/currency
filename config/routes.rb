Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root to: 'application#index'

  namespace :admin do
    resources :exchange_rates, only: [:index, :create], path: ''
  end
end
