class AddWhisperModelAndWhisperTxtToVideos < ActiveRecord::Migration[7.0]
  def change
    # if whisper_model is set, then we know that whisper has been run
    add_column :videos, :whisper_model, :string  # medium, large, base...
    add_column :videos, :whisper_txt, :text
  end
end
