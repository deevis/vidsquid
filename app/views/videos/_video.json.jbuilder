json.extract! video, :id, :file_on_disk, :title, :tag_list, :whisper_txt, :whisper_model, :download_url, :byte_size, :checksum, :created_at, :updated_at
json.url video_url(video, format: :json)
