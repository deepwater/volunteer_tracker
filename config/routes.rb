VolunteerTracker::Application.routes.draw do

  root :to => 'dashboard#index'

  # PUBLIC FACING
  resources :departments, :only => [:index,:show]
  resources :charities, :only => [:index,:show]

  devise_for :users, :controllers => { registrations: "registrations"}
  devise_for :users

  match '/welcome' => "welcome#index"

  resources :admin, :only => :index
  match 'admin/list' => "admin#list"
  
  namespace :admin do
    resources :users
    resources :charities
    resources :departments
    resources :department_managers
    resources :department_assistants
  end

  resources :dashboard, :only => [:index, :registration_complete]
  namespace :dashboard do
    # VIEWING ONLY
    resources :departments, :only => [:show, :edit]
    resources :user_charities

    # ROLES
    resources :department_assistants
    resources :volunteer_managers
    resources :users

    # TIME RELATED
    resources :days
    resources :user_availabilities
    resources :department_blocks
    resources :user_schedules

    match 'check_ins/scheduled' => "check_ins#scheduled"
    match 'check_ins/active' => "check_ins#active"
    match 'check_ins/inactive' => "check_ins#inactive"
    resources :check_ins



    match 'department_blocks/:id/copy/' => "department_blocks#copy"
  end

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
  # match ':controller(/:action(/:id))(.:format)'
end
