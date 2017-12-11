Rails.application.routes.draw do
  devise_for :users

  resources :groups do
    resources :projects, except: :show, shallow: true do
      resources :tasks, shallow: true
      resources :project_user_relations, path: :users, except: :show, shallow: true
    end
  end
end
