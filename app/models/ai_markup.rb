# == Schema Information
#
# Table name: ai_markups
#
#  id                    :bigint           not null, primary key
#  video_id              :bigint           not null
#  summary_1             :string(1400)
#  summary_2             :string(1400)
#  summary_3             :string(1400)
#  title_1               :string(300)
#  title_2               :string(300)
#  title_3               :string(300)
#  hashtags_1            :string(200)
#  hashtags_2            :string(200)
#  hashtags_3            :string(200)
#  people_identified     :string(256)
#  places_identified     :string(256)
#  generating_model_name :string(128)
#  summary_chosen        :integer
#  title_chosen          :integer
#  hashtags_chosen       :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  timing_json           :text(65535)
#
class AiMarkup < ApplicationRecord
  belongs_to :video

  validates :video_id, presence: true
  validates :generating_model_name, presence: true

  before_save :trim_hashtags

  def timings
    return {} if timing_json.nil?
    JSON.parse(timing_json)
  end

  private
  def trim_hashtags
    self.hashtags_1 = AiMarkup.trim_hashtags(self.hashtags_1)
    self.hashtags_2 = AiMarkup.trim_hashtags(self.hashtags_2)
    self.hashtags_3 = AiMarkup.trim_hashtags(self.hashtags_3)
  end

  def self.trim_hashtags(hashtags)
    return hashtags if hashtags.nil? || hashtags.length <= 200
    tags = hashtags.split(', ')
    while tags.join(', ').length > 200
      Rails.logger.info "Discarding tag: #{tags.last}"
      tags.pop
    end
    tags.join(', ')
  end
end
