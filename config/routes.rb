Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "/no_community", to: "pages#no_community"

  resources :communities do
    resources :chats, only: [:index, :new, :create]
    resources :common_expenses, only: [:new, :create, :index]
    resources :common_spaces, only: [:new, :create, :index]
    resources :residents, only: [:index]
  end

  resources :administrators, only: [:new, :create, :destroy]
  resources :residents, only: [:new, :create, :show, :edit, :update, :destroy] do
    member do
      get :auth_waiting
      get :already_resident
    end
  end

  resources :common_spaces, only: [:show, :destroy, :edit, :update] do
    # resources :bookings, only: [:create] #para ver las reservas dentro de los common spaces y posteriormente hacer una reserva
    resources :bookings, only: [:index, :new, :create, :show]
    resources :usable_hours, only: [:create, :update]
  end

  resources :usable_hours, only: [:destroy]

  #resources :bookings, only: [:show, :destroy, :edit, :update, :index]
  resources :bookings, only: [:destroy, :edit, :update]

  resources :common_expenses, only: [:show, :destroy, :edit, :update] do
    resources :expense_details, only: [:new, :create, :index]
  end

  resources :expense_details, only: [:show, :destroy, :edit, :update]

  resources :chats, only: [:show, :destroy, :edit, :update] do
    collection do
      get :hidden
    end
    resources :messages, only: [:create, :destroy]
  end

  resources :show_chats, only: [:create, :update]

  patch "expense_details_residents/:id/pay", to: "expense_details_residents#pay", as: :pay_expense
  patch "expense_details_residents/:id/approve", to: "expense_details_residents#approve", as: :approve_expense
  patch "expense_details_residents/:id/reject",  to: "expense_details_residents#reject",  as: :reject_expense


end
