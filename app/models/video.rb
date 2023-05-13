class Video < ApplicationRecord
  has_one_attached :file
  acts_as_taggable_on :tags

  # Gets called when ActiveStorage file changes
  after_touch :set_stats

  def file_on_disk
    ActiveStorage::Blob.service.path_for(file.key)
  end

  # whisper_tsv - Returns the timecoded transcription TSV file's contents
  # 
  # eg: 
  # start  end  text
  # 0  3400  If you look at the last five years, gold is actually up only around 39%.
  # 3400  6400  It's not really done anything, whereas Bitcoin is up 3,200%.
  # 6400  10600  Perhaps we live in an entirely new era and a new time where my generation,
  # 10600  14200  millennials, actually do see value in something which is digital rather than
  
  def whisper_tsv
    filepath = "#{file_on_disk}.tsv"
    if File.exist?(filepath)
      File.readlines(filepath).join
    else
      nil
    end
  end

  def read_whisper_txt
    filepath = "#{file_on_disk}.txt"
    if File.exist?(filepath)
      File.readlines(filepath).join.gsub("\r\n", "\n")
    else
      raise "No transcription file: #{filepath}"
    end
  end

  def populate_whisper_data(model_used='medium')  # large, base
    self.whisper_txt = read_whisper_txt
    self.whisper_model = model_used
    self.save!
  end

  def self.populate_whisper_data(model_used='medium')  # large, base
    # First, get the videos that don't have whisper attributes, but do have whisper files created
    newly_transcribed = Video.find_each.select{|v| v.whisper_tsv.present? && v.whisper_txt.nil?}
    count = 0
    errors = []
    newly_transcribed.each do |v|
      begin
        v.populate_whisper_data(model_used)
        count += 1
      rescue => e
        errors << {video_id: v.id, error: e.message}
      end
    end
    { count: count, errors: errors }
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
