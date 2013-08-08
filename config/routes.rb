Onedooropen::Application.routes.draw do

  root :to => "access#index"
  match 'nibblerarea', :to => 'manageusers#index'
  match 'profile', :to => 'profile#show'
  match 'profile/tagged', :to => 'profile#tagged'
  match 'profile/:id', :to => 'profile#usersprofile'
  match 'profile/settings', :to => 'settings#settingspage'
  match 'profile/changespassword', :to => 'settings#changepassword'
  match 'thanksforfeedback', :to => 'settings#thanks'
  match 'register', :to => 'access#register'
  match 'activateaccount', :to => 'access#activate'
  match 'resetpassword', :to => 'access#resetpassword'
  match 'changepassword', :to => 'access#confirmedNowNewPassword'
  
  
   # resources :profile do
     # member do
       # get :following, :followers
     # end
   # end
    resources :relationships, only: [:create, :destroy]
    
     match 'profile/tagged', :to => 'profile#tagged'
     #match 'profile/tagged' => 'profile#tagged', :as => 'tagged'
     match 'explore/tagged' => 'explore#tagged', :as => 'tagged'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   match ':controller(/:action(/:id))(.:format)'
end
