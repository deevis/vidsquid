class AiMarkupFieldSizes < ActiveRecord::Migration[7.0]
  def change
    # make hashtag fields in ai_markups 200 characters
    change_column :ai_markups, :summary_1, :string, limit: 1400    
    change_column :ai_markups, :summary_2, :string, limit: 1400    
    change_column :ai_markups, :summary_3, :string, limit: 1400    

    change_column :ai_markups, :title_1, :string, limit: 300    
    change_column :ai_markups, :title_2, :string, limit: 300    
    change_column :ai_markups, :title_3, :string, limit: 300    

    change_column :ai_markups, :hashtags_1, :string, limit: 200    
    change_column :ai_markups, :hashtags_2, :string, limit: 200    
    change_column :ai_markups, :hashtags_3, :string, limit: 200    
  end
end

