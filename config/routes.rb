Rails.application.routes.draw do
  resources :contracts
    post 'analyze', on: :member
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
