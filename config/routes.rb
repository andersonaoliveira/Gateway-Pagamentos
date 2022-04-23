Rails.application.routes.draw do
  devise_for :admins
  root to: 'home#index'

  get 'search_coupons', to: 'coupons#search'

  resources :card_banners, only: %i[show new create index edit update] do
    patch :activate, on: :member
    patch :disable, on: :member
  end

  resources :charges, only: %i[index show] do
    patch :approve, on: :member
    get 'reprove', on: :member
    post 'reprove_msn', on: :member
    get :search, on: :collection
    get 'approved', on: :collection
    get 'reproved', on: :collection
    get 'pending', on: :collection
  end

  resources :sales, only: %i[show new create index edit update] do
    patch :approve, on: :member
    post :disapprove_msg, on: :member
    get :disapprove, on: :member
    get :search, on: :collection
    post 'generate_coupons', on: :member
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :credit_cards, only: [:create]
      resources :card_banners, only: %i[index show]
      resources :charges, only: [:create]
      get 'coupons/validate_coupon', to: 'coupons#validate_coupon'
    end
  end
end
