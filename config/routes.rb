Rails.application.routes.draw do
  resources :videos do
    member do
      get :add_tag
      get :remove_tag
    end
    collection do
      get :rabbithole
      get :next_untagged_video
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "videos#index"
end
