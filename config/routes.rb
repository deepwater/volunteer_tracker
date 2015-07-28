VolunteerTracker::Application.routes.draw do

  # PUBLIC FACING
  resources :departments, only: [:index, :show]
  resources :charities, only: [:index, :show]

  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'sessions',
    passwords: 'passwords'
  }

  resources :users, only: [:edit] do
    resources :user_availabilities, only: [:index, :create, :destroy]
    resources :subaccounts do
      post :import, on: :collection
    end
  end

  get '/welcome' => 'welcome#index'

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
    resources :department_assistants, only: [:create, :destroy, :restrict]
    resources :volunteer_managers, only: [:create, :destroy]
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
        get :get_user_list
      end
    end

    resources :check_ins do
      collection do
        get :scheduled
        get :manage
        get :active
        get :inactive
        get :fastpass
        get :manage
        put :update_batch
        post :create_batch
        post :is_accessible
      end
    end
    get 'volunteers/:year/:month/:day' => 'volunteers#index'

    get 'check_ins/scheduled/:day_id' => "check_ins#scheduled"
    get 'check_ins/active/:day_id' => "check_ins#active"
    get 'check_ins/inactive/:day_id' => "check_ins#inactive"

    get 'volunteers/:day_id' => "volunteers#index", as: :volunteers

    get 'check_outs/fastpass' => "check_ins#fastpass_out", as: :fastpass_check_out
    post 'check_outs' => "check_ins#check_out", as: :check_out

    resources :flags

    get 'department_blocks/:id/copy/' => 'department_blocks#copy'
    get 'departments/:id/export/:year/:month/:day' => 'department_blocks#export'
    get 'departments/:id/schedule/:year/:month/:day' => 'departments#schedule'
  end

  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end
  unauthenticated do
    devise_scope :user do
      root to: 'devise/sessions#new', as: :root
    end
  end
end
