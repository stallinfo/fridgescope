Rails.application.routes.draw do

  resources :fridges
  resources :facilities
  resources :services
  root 'static_pages#home'
  #get 'static_pages/home'
  #get 'static_pages/help'
  #get 'static_pages/about'
  #get 'static_pages/contact'
  get '/help', to: 'static_pages#help'
  get 'about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/service_manager_signup', to: 'service_managers#new'
  get '/administrator_signup', to: 'administrators#new'
  get '/facility_manager_signup', to: 'facility_managers#new'
  get '/facility_manager_login', to: 'facility_manager_sessions#new'
  get '/service_manager_login', to: 'service_manager_sessions#new'
  get '/administrator_login', to: 'administrator_sessions#new'
  post '/facility_manager_login', to: 'facility_manager_sessions#create'
  post '/service_manager_login', to: 'service_manager_sessions#create'
  post '/administrator_login', to: 'administrator_sessions#create'
  delete '/facility_manager_logout', to: 'facility_manager_sessions#destroy'
  delete '/service_manager_logout', to: 'service_manager_sessions#destroy'
  delete '/administrator_logout', to: 'administrator_sessions#destroy'
  post '/service_search', to: 'services#search'
  get '/service_confirmation_path', to: 'services#confirmation'
  post '/facility_search', to: 'facilities#search'


  #API
  get 'apis/login'
  get 'apis/lightlogin'
  post '/uploadimage', to: 'apis#upload'


  resources :administrators
  resources :service_managers
  resources :facility_managers

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
