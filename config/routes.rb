Rails.application.routes.draw do
  resources :videos do
    member do
      get :add_tag
      get :remove_tag
      get :set_title
      post :populate_whisper_transcription, format: :json # whisper_txt, whisper_tsv, whisper_model
      post :populate_ai_markup, format: :json # generating_model_name, summary_1, title_1, hashtags_1, people_identified, places_identifed
    end
    collection do
      get :untitled
      get :rabbithole
      get :next_untagged_video
      get :list_untagged_video_paths, format: :json
      get :list_untranscribed_video_paths, format: :json
      get :list_transcribed_video_paths, format: :json
      get :list_no_ai_markup_for_model_videos, format: :json
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "videos#index"
end
