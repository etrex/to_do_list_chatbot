Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'line', to: 'line#entry'
  get 'test', to: 'line#test'
  resources :todo
end
