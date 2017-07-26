Rails.application.routes.draw do

  root to: 'home#index'

  # header
  get 'home/index' => 'home#index'
  get '/home/profile' => 'home#profile'

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
  post '/home/profile_update' => 'home#profile_update'
  post '/home/file_upload' => 'home#file_upload'
  get '/destroy_file/:file_id' => 'home#destroy_file'
  get '/destroy_transaction/:trans_id' => 'home#destroy_transaction'
  delete '/announcements.:ann_id' => 'home#destroy_announcement'
  delete '/p/:p_id' => 'home#destroy_poll'
  resources :announcements
  resources :p

  #Group
  get '/home/create_group_view' => 'home#create_group_view'
  get '/home/create_group' => 'home#create_group'
  get '/home/group_page/:group_id' => 'home#group_page'
  get '/home/search' => 'home#search'
  post '/home/join_group/:group_id' => 'home#join_group'

  #Group_Home_Functions
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
  get '/home/my_calendar' => 'home#my_calendar'

  get '/home/ann_read' => 'home#ann_read'
  get '/home/cal_read' => 'home#cal_read'
  get '/home/budget_read' => 'home#budget_read'
  get '/home/poll_read' => 'home#poll_read'

  get '/home/group_profile/:group_id' => 'home#group_profile'
  post '/home/group_edit' => 'home#group_edit'

  post '/home/add_event' => 'home#add_event'
  get '/home/cancel_event' => 'home#cancel_event'

  get '/landing/landing_page' => 'landing#landing_page'
  get '/landing/index' => 'landing#index'
  #Calendar
  resources :events

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
