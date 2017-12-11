Rails.application.routes.draw do
  devise_for :users

  resources :projects do
    resources :tasks, shallow: true
  end
end
