class CreateAiMarkups < ActiveRecord::Migration[7.0]
  def change
    create_table :ai_markups do |t|
      t.references :video, null: false, foreign_key: true
      t.string :summary_1, limit: 1000
      t.string :summary_2, limit: 1000
      t.string :summary_3, limit: 1000
      t.string :title_1, limit: 200
      t.string :title_2, limit: 200
      t.string :title_3, limit: 200
      t.string :hashtags_1, limit: 100
      t.string :hashtags_2, limit: 100
      t.string :hashtags_3, limit: 100
      t.string :people_identified, limit: 256
      t.string :places_identified, limit: 256
      t.string :generating_model_name, limit: 128
      t.integer :summary_chosen
      t.integer :title_chosen
      t.integer :hashtags_chosen

      t.timestamps
    end
  end
end
