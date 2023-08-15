# == Schema Information
#
# Table name: videos
#
#  id            :bigint           not null, primary key
#  title         :string(255)
#  byte_size     :integer
#  checksum      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  filename      :string(255)
#  whisper_model :string(255)
#  whisper_txt   :text(65535)
#  whisper_tsv   :text(65535)
#
require "test_helper"

class VideoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
