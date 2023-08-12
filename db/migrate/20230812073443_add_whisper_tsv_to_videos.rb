class AddWhisperTsvToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :whisper_tsv, :text
  end
end
