Rails.application.routes.draw do
  
  get 'subscribe' => 'charges#new', :as => :subscribe
  post 'subscribe' => 'charges#create'
  get 'subscribe/renew' => 'charges#renew', :as => :renew

  root :to => 'users#new'

  get 'reset-password' => 'password_resets#new', :as => :new_password_reset
  post 'reset-password' => 'password_resets#create', :as => :password_resets
  get 'reset-password/:id' => 'password_resets#edit', :as => :password_reset
  patch 'reset-password/:id' => 'password_resets#update'
  put 'reset-password/:id' => 'password_resets#update'
  
  get 'sign-up' => 'users#new', :as => :new_user
  post 'sign-up' => 'users#create', :as => :users

  get 'profile' => 'users#edit', :as => :user
  patch 'profile' => 'users#update'
  put 'profile' => 'users#update'

  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => 'user_sessions#create'
  post 'logout' => 'user_sessions#destroy', :as => :logout
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
