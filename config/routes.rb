Rails.application.routes.draw do

  root to: 'home#index'

  # header
  get 'home/index'
  get '/home/profile' => 'home#profile'
  get '/home/my_friends' => 'home#my_friends'
  get '/home/setting' => 'home#setting'

  #profile
  post 'home/group_color' => 'home#group_color'

  # user
  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions =>"users/sessions",
    :passwords =>"users/passwords",
    :confirmations =>"users/confirmations",}
  get 'sign_up' => 'users/registrations#new'
  get 'sign_in' => 'users/sessions#new'
  get 'sign_out' => 'users/sessions#destroy'
  get 'edit' => 'users/registrations#edit'
  # uploading profile picture
  post '/uploadprofpic' => 'home#uploadprofpic'

  #Group
  get '/home/create_group_view' => 'home#create_group_view'
  get '/home/create_group' => 'home#create_group'
  get '/home/group_page/:group_id' => 'home#group_page'
  post '/home/search' => 'home#search'
  post '/home/join_group/:group_id' => 'home#join_group'

  #Gruop_Home_Functions
  get '/home/announcement' => 'home#announcement'
  get '/home/announcement_all' => 'home#announcement_all'
  get '/home/event_rsvp/' => 'home#event_rsvp'
  post '/home/money_plus' => 'home#money_plus'
  post '/home/money_minus' => 'home#money_minus'
  get '/home/new_poll' => 'home#new_poll'
  get '/home/add_option' => 'home#add_option'
  get '/home/option_select' => 'home#option_select'
  get '/home/option_cancel' => 'home#option_cancel'
  get '/home/delete_poll' => 'home#delete_poll'

  post '/home/ann_read' => 'home#ann_read'
  post '/home/cal_read' => 'home#cal_read'
  post '/home/budget_read' => 'home#budget_read'
  post '/home/poll_read' => 'home#poll_read'

  #Calendar
  resources :events


  #Chat
  get '/rooms/show' => 'rooms#show'
  get '/rooms/new_chat' => 'rooms#new'

  resources :conversations, only: [:create] do
   member do
     post :close
   end

   resources :messages, only: [:create]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
