json.extract! video, :id, :title, :filesize, :md5, :created_at, :updated_at
json.url video_url(video, format: :json)
