Rails.application.routes.draw do

  scope module: 'public' do
    resource :session, only: [ :new, :create, :destroy ]
    resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    root to: 'homes#top'
    get 'about' => 'homes#about'
    resources :items, only: [:index, :show]
    get 'customers/sign_up', to: 'registrations#new'
    post 'customers', to: 'registrations#create'

    get 'customers/my_page', to: 'customers#show'
    get 'customers/information/edit', to: 'customers#edit'
    patch 'customers/information', to: 'customers#update'
    get 'customers/unsubscribe', to: 'customers#unsubscribe'
    patch 'customers/withdraw', to: 'customers#withdraw'

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

  # 管理者用
  namespace :admin do
    get "customers/index"
    get "customers/show"
    get "customers/edit"
    get "customers/update"
    root to: "homes#top"
    resource :session, only: [:new, :create, :destroy], path: "", path_names: { new: "sign_in" }
    resources :items, only: [:new, :create, :show, :edit, :update, :index]
    resources :genres, only: [:create, :index, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
