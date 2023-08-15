class AddTimingJsonToAiMarkups < ActiveRecord::Migration[7.0]
  def change
    add_column :ai_markups, :timing_json, :text
  end
end
