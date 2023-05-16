Rails.application.routes.draw do
  resources :videos do
    member do
      get :add_tag
      get :remove_tag
      post :populate_whisper_transcription, format: :json # whisper_txt, whisper_tsv, whisper_model
    end
    collection do
      get :rabbithole
      get :next_untagged_video
      get :list_untagged_video_paths, format: :json
      get :list_untranscribed_video_paths, format: :json
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "videos#index"
end
