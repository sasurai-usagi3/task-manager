Rails.application.routes.draw do
  devise_for :users, module: :users

  resources :groups, except: [:index, :show] do
    resources :projects, except: :show, shallow: true do
      resources :tasks, shallow: true
      resources :project_user_relations, path: :project_members, except: :show, shallow: true
    end
    resources :group_user_relations, path: :group_members, except: :show, shallow: true
  end

  root 'home#index'
end
