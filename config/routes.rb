Rails.application.routes.draw do
  get "ledger_transactions/create"
  get "accounts/create"
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  resources :accounts, only: %i[create]
  resources :ledger_transactions, only: %i[create]
end
