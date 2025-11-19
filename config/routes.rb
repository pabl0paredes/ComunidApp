Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :communities do
    resources :chats, only: [:index, :new, :create]
    resources :common_expenses, only: [:new, :create, :index]
    resources :common_spaces, only: [:new, :create, :index]
    resources :neighbors, only: [:index, :new, :create]
    resources :administrators, only: [:show]
  end

  resources :administrators, only: [:new, :create, :destroy]
  resources :neighbors, only: [:show, :edit, :update, :destroy]

  resources :common_spaces, only: [:show, :destroy, :edit, :update] do
    resources :bookings, only: [:create]
    resources :usable_hours, only: [:create, :update]
  end

  resources :usable_hours, only: [:destroy]

  resources :bookings, only: [:show, :destroy, :edit, :update, :index]

  resources :common_expenses, only: [:show, :destroy, :edit, :update] do
    resources :expense_details, only: [:new, :create, :index]
  end

  resources :expense_details, only: [:show, :destroy, :edit, :update]

  resources :chats, only: [:show, :destroy, :edit, :update] do
    collection do
      get :hidden
    end
    resources :messages, only: [:create]
  end

  resources :show_chats, only: [:create, :update]

end
