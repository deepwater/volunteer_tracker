VolunteerTracker::Application.routes.draw do

  # PUBLIC FACING
  resources :departments, :only => [:index,:show]
  resources :charities, :only => [:index,:show]

  devise_for :users, :controllers => { registrations: "registrations"}
  devise_for :users

  match '/welcome' => "welcome#index"

  resources :admin, :only => :index do
    collection do
      get :charity_tab
      get :department_tab
      get :event_tab
      get :organisation_tab
    end
  end
  match 'admin/list' => "admin#list"
  
  namespace :admin do
    resources :users
    resources :charities
    resources :departments
    resources :department_managers
    resources :department_assistants
    resources :events
    resources :organisations
  end

  constraints(Subdomain) do
    match '/' => 'organisations#show', as: :organisation_root
  end

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
