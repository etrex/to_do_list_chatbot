Rails.application.routes.draw do

  # index page
  root to: "todos#index"

  # sign in and sign up
  devise_for :users

  # line webhook entry
  post 'line', to: 'line#entry'

  # liff form
  get 'liff_form', to: 'line#liff_form'

  get 'test', to: 'line#test'
  # todo
  resources :todos
end
