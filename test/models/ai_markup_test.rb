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
require "test_helper"

class AiMarkupTest < ActiveSupport::TestCase
  test "long hashtags get trimmed appropriately" do
    # 15 hashtags
    s = "philosophy, fallacies, logicalreasoning, argumentation, epistemology, lifesummary, timeisshort, beingmegaefficient, focusingontheimportantstuff, eliminatetheunnecessary, Rappers, Freestyle, Lyricism, SpittingFire, KillingIt"
    tags = s.split(', ')
    L.info "s.length = #{s.length}"
    L.info "tags.length = #{tags.length}"
    L.info "tags = #{tags}"
    assert tags.length == 15
    assert s.length > 200
    trimmed = AiMarkup.trim_hashtags(s)
    L.info "trimmed.length = #{trimmed.length}"
    trimmed_tags = trimmed.split(', ')
    L.info "trimmed_tags.length = #{trimmed_tags.length}"
    newly_created_tags = trimmed_tags - tags
    assert newly_created_tags.length == 0
    discarded_tags = tags - trimmed_tags
    L.info "discarded_tags.length = #{discarded_tags.length}"
    L.info "discarded_tags = #{discarded_tags}"
    assert discarded_tags.length > 1
  end

  test "nil hashtags don't break the system" do
    nilTrim = AiMarkup.trim_hashtags(nil)
    L.info "nilTrim = #{nilTrim}"
    assert true
  end
end
