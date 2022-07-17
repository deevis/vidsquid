class Video < ApplicationRecord
  has_one_attached :file
  acts_as_taggable_on :tags

  # Gets called when ActiveStorage file changes
  after_touch :set_stats

  def file_on_disk
    ActiveStorage::Blob.service.path_for(file.key)
  end

  def self.import_videos(path = "/mnt/e/unnamed-tiktok-videos")
    counts = Hash.new(0)
    Dir.glob("#{path}/*.mp4").each do |filepath|
      filename = filepath.split("/").last
      if Video.find_by(filename: filename).present?
        puts "Skipping: #{filepath}"
        counts[:skipped] += 1
      else
        v = Video.create(title: filename)
        v.file.attach(io: File.open(filepath), filename: filename)
        puts "Imported: #{filepath}"
        counts[:imported] += 1
      end
    end
    counts
  end

  private
  def set_stats
    self.checksum = file.checksum
    self.byte_size = file.byte_size
    self.filename = file.filename.to_s
    self.save!
  end
end
