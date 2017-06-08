Rails.application.routes.draw do



  use_doorkeeper do
  skip_controllers :authorizations, :applications,
    :authorized_applications
  end


  namespace :api do
	devise_for :users,
	   only: :registrations,
	   controllers: {
	     registrations: 'api/users/registrations'
	   }

    #User
    match '/activate_account', to: 'users#activate_account', via: 'post'
    match '/resend_activation_code', to: 'users#resend_activation_code', via: 'post'
    match '/change_password', to: 'users#change_my_password', via: 'put'
    match '/change_username', to: 'users#change_my_username', via: 'put'
    match '/my_profile', to: 'users#my_profile', via: 'get'
    match '/my_tokens', to: 'users#my_tokens', via: 'get'
    match '/users/:id', to: 'users#show', via: 'get'
    match '/edit_my_profile', to: 'users#edit_my_profile', via: 'put'
    match '/send_a_new_password', to: 'users#send_new_password', via: 'post'
    match '/index' ,to:'users#index' ,via:'get'
    match '/upload_avatar', to: 'users#upload_avatar', via: 'put'

    # Article
    resources :articles
    match 'article/upload_avatar/:id', to: 'articles#upload_avatar', via: 'put'
  match 'article/sort', to: 'articles#index', via: 'post'
  match 'article/search', to: 'articles#search', via: 'post'

    resources :favorites
    resources :add_category_tables
  end
end
