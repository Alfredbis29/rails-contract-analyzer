Rails.application.routes.draw do
  resources :contracts do
    post 'analyze', on: :member
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
