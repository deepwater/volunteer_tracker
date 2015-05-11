VolunteerTracker::Application.routes.draw do

  # PUBLIC FACING
  resources :departments, only: [:index, :show]
  resources :charities, only: [:index, :show]

  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions",
    passwords: "passwords"
  }

  resources :users do
    collection do
      get :edit_profile
    end
    resources :user_availabilities, only: [:index, :create, :destroy]
    resources :subaccounts do
      post :import, on: :collection
    end
  end

  match '/welcome' => "welcome#index"

  namespace :admin do
    resources :users
    resources :charities
    resources :departments
    resources :department_managers
    resources :department_assistants do
      member { post :restrict_blocks }
      member { get :show_modal }
    end
    resources :events
    resources :organisations

    resources :base, only: :index do
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

  resources :dashboard, only: [:index, :registration_complete]
  namespace :dashboard do
    # VIEWING ONLY
    resources :departments, only: [:show, :edit] do
      member do
        get :for_promote
        get :assistants
      end
    end
    resources :user_charities

    # ROLES
    resources :department_assistants
    resources :volunteer_managers
    resources :volunteers, only: [:index]
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


    resources :become_users do
      collection do
        get :accept_transfer
        get :decline_transfer
      end
    end

    resources :check_ins do
      collection do
        get :scheduled
        get :active
        get :inactive
        get :fastpass
        put :update_batch
        post :create_batch
      end
    end

    match 'check_ins/scheduled/:year/:month/:day' => "check_ins#scheduled"
    match 'check_ins/active/:year/:month/:day' => "check_ins#active"
    match 'check_ins/inactive/:year/:month/:day' => "check_ins#inactive"

    get 'check_outs/fastpass' => "check_ins#fastpass_out", as: :fastpass_check_out
    post 'check_outs' => "check_ins#check_out", as: :check_out

    resources :flags

    match 'department_blocks/:id/copy/' => "department_blocks#copy"
    match 'departments/:id/export/:year/:month/:day' => "department_blocks#export"
    match 'departments/:id/schedule/:year/:month/:day' => "departments#schedule"
  end

  authenticated :user do
    root :to => 'dashboard#index'
  end

  unauthenticated do
    devise_scope :user do
      root :to => 'devise/sessions#new'
    end
  end
end
