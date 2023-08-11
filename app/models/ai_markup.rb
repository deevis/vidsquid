# == Schema Information
#
# Table name: ai_markups
#
#  id                    :bigint           not null, primary key
#  video_id              :bigint           not null
#  summary_1             :string(1000)
#  summary_2             :string(1000)
#  summary_3             :string(1000)
#  title_1               :string(200)
#  title_2               :string(200)
#  title_3               :string(200)
#  hashtags_1            :string(100)
#  hashtags_2            :string(100)
#  hashtags_3            :string(100)
#  people_identified     :string(256)
#  places_identified     :string(256)
#  generating_model_name :string(128)
#  summary_chosen        :integer
#  title_chosen          :integer
#  hashtags_chosen       :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class AiMarkup < ApplicationRecord
  belongs_to :video
end
