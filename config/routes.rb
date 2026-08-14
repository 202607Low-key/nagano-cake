Rails.application.routes.draw do
  scope module: 'public' do

    resource :session, only: [ :new, :create, :destroy ]
    resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    root to: 'homes#top'
    get 'about' => 'homes#about'
    resources :items, only: [:index, :show]
    resources :customers, only: [:show, :edit, :update, :destroy] do
      member do
        get 'confirm'
      end
    end
    resources :cart_items, only: [:index, :update, :create, :destroy] do
      collection do
        delete 'all_destroy'
      end
    end
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
        get 'confirm'
        get 'complete'
      end
    end
    resources :addresses, only: [:index, :edit, :create, :update, :destroy]
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
