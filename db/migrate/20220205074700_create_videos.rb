class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.integer :byte_size
      t.string :checksum

      t.timestamps
    end
  end
end
