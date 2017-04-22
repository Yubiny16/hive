Rails.application.routes.draw do
  get 'rooms/show'

  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions =>"users/sessions",
    :passwords =>"users/passwords",
    :confirmations =>"users/confirmations",}
  root to: 'home#index'
  get 'home/index'
  get 'sign_up' => 'users/registrations#new'
  get 'sign_in' => 'users/sessions#new'
  get 'sign_out' => 'users/sessions#destroy'
  get 'edit' => 'users/registrations#edit'
  get '/home/create_group_view' => 'home#create_group_view'
  get '/home/create_group' => 'home#create_group'
  get '/home/group_page/:group_id' => 'home#group_page'
  post '/home/search' => 'home#search'
  get '/home/join_group/:group_id' => 'home#join_group'

  get '/home/profile' => 'home#profile'
  get '/home/my_friends' => 'home#my_friends'

  get '/events/new' => 'events#new'

  get '/rooms/show' => 'rooms#show'
  get '/rooms/new_chat' => 'rooms#new'

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
