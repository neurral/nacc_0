Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root 'welcome#index'
  #resources :users, :user_identities
  
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

  get 'welcome/index'

  root 'welcome#index'

  #get 'login' => 'sessions#login'
  # post 'login' => 'sessions#login' # login,return session_key if successful'
  # post 'check' => 'sessions#check' # session_key validate test via post
  # post 'logout' => 'sessions#logout'

  post 'login' => 'users#login' # login,return session_key if successful'
  post 'logout' => 'users#logout'
  post 'request-token/:username' => 'users#request_token'
  # get 'in/:username/:token' => 'users#activate_token'
  post 'in' => 'users#activate_token' #should have an equivalent in frontend

  # User Management
  #resources :users
  # put 'register' => 'users#create' # TODO fix CORS for OPTIONS
  post 'register' => 'users#create' 
  patch 'users/update/:username' => 'users#update'
  get 'user' => 'users#list'
  get 'users/:username' => 'users#show'
  post 'users/delete' => 'users#deactivate'


end
