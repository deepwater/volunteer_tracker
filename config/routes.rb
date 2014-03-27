VolunteerTracker::Application.routes.draw do

  # PUBLIC FACING
  resources :departments, :only => [:index,:show]
  resources :charities, :only => [:index,:show]

  devise_for :users, :controllers => { registrations: "registrations"}
  resources :users do
    resources :subaccounts do
      collection { post :import }
    end
  end

  match '/welcome' => "welcome#index"
  
  namespace :admin do
    resources :users
    resources :charities
    resources :departments
    resources :department_managers
    resources :department_assistants
    resources :events
    resources :organisations

    resources :base, :only => :index do
      collection do
        get :charity_tab
        get :department_tab
        get :event_tab
        get :organisation_tab
      end
    end
    match 'list' => "base#list"
    root to: 'base#index'
  end

  # constraints(Subdomain) do
  #   match '/' => 'organisations#show', as: :organisation_root
  # end

  resources :dashboard, :only => [:index, :registration_complete]
  namespace :dashboard do
    # VIEWING ONLY
    resources :departments, :only => [:show, :edit] do
      member do
        get :for_promote
        get :assistants
      end
    end
    resources :user_charities

    # ROLES
    resources :department_assistants
    resources :volunteer_managers
    resources :users

    # TIME RELATED
    resources :days
    resources :users do
      resources :user_availabilities
      resources :user_charities
    end
    resources :user_availabilities
    resources :department_blocks

    resources :user_schedules do
      get :dymo, on: :member
    end

    resources :check_ins do
      collection do
        get :scheduled
        get :active
        get :inactive
        get :fastpass
      end
    end

    get 'check_outs/fastpass' => "check_ins#fastpass_out", as: :fastpass_check_out
    post 'check_outs' => "check_ins#check_out", as: :check_out

    resources :flags

    match 'department_blocks/:id/copy/' => "department_blocks#copy"
    match 'departments/:id/export/:year/:month/:day' => "department_blocks#export"
    match 'departments/:id/schedule/:year/:month/:day' => "departments#schedule"
  end
  root :to => 'dashboard#index'
end
