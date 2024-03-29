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
class Video < ApplicationRecord
  has_many :ai_markups, dependent: :destroy
  has_one_attached :file
  acts_as_taggable_on :tags


  # Gets called when ActiveStorage file changes
  after_touch :set_stats

  def file_on_disk
    return nil if file.key.nil?
    ActiveStorage::Blob.service.path_for(file.key)
  end


  def download_url
    return nil if file.nil?
    file.url
  end

  # whisper_tsv - Returns the timecoded transcription TSV file's contents
  # 
  # eg: 
  # start  end  text
  # 0  3400  If you look at the last five years, gold is actually up only around 39%.
  # 3400  6400  It's not really done anything, whereas Bitcoin is up 3,200%.
  # 6400  10600  Perhaps we live in an entirely new era and a new time where my generation,
  # 10600  14200  millennials, actually do see value in something which is digital rather than
  
  def read_whisper_tsv
    return nil if file.nil?
    filepath = "#{file_on_disk}.tsv"
    if File.exist?(filepath)
      File.readlines(filepath).join
    else
      nil
    end
  end

  # def set_whisper_tsv(whisper_tsv)
  #   return nil if file.nil?
  #   filepath = "#{file_on_disk}.tsv"
  #   File.open(filepath, 'w') do |f|
  #     f.write(whisper_tsv)
  #   end
  # end
  
  def read_whisper_txt
    filepath = "#{file_on_disk}.txt"
    if File.exist?(filepath)
      File.readlines(filepath).join.gsub("\r\n", "\n")
    else
      raise "No transcription file: #{filepath}"
    end
  end

  # generating_model_name, summary_x, title_x, hashtags_x, people_identified, places_identifed
  def populate_ai_markup(fields)
    # only let legal column through
    fields = fields.with_indifferent_access
    timings = fields.delete(:timings)
    if timings.present?
      fields[:timing_json] = timings.to_json
    end
    fields = fields.slice(*AiMarkup.column_names)
    ai_markup = self.ai_markups.where(generating_model_name: fields[:generating_model_name]).first_or_create do |am|
      fields.each do |k,v|
        puts "Param[#{k}] => #{v}"
        am.send("#{k}=", v)
      end 
    end
  end

  # populate_whisper_data - 1 mode:
  #     1) whisper_txt and whisper_tsv are provided, and we use provided values
  #     (deprecated) - 2) whisper_txt and whisper_tsv are NOT provided, and we use data in the file system
  # 
  def populate_whisper_data(whisper_txt: nil, whisper_tsv: nil, whisper_model: 'medium')  # large, base
    raise "No whisper_txt provided" if whisper_txt.nil?
    raise "No whisper_tsv provided" if whisper_tsv.nil?
    self.whisper_txt = whisper_txt
    self.whisper_tsv = whisper_tsv
    self.whisper_model = whisper_model
    self.save!
  end

  # def self.populate_whisper_data(whisper_model='medium')  # large, base
  #   # First, get the videos that don't have whisper attributes, but do have whisper files created
  #   newly_transcribed = Video.find_each.select{|v| v.whisper_tsv.present? && v.whisper_txt.nil?}
  #   count = 0
  #   errors = []
  #   newly_transcribed.each do |v|
  #     begin
  #       v.populate_whisper_data(whisper_model)
  #       count += 1
  #     rescue => e
  #       errors << {video_id: v.id, error: e.message}
  #     end
  #   end
  #   { count: count, errors: errors }
  # end





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
