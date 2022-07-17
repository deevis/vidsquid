class VideosController < ApplicationController
  before_action :set_video, only: %i[ show edit update destroy add_tag remove_tag]

  def add_tag
    @video.tag_list.add(params[:tag], parse: true)
    @video.save!
    redirect_to @video
  end

  def remove_tag
    @video.tag_list.remove(params[:tag], parse: true)
    @video.save!
    redirect_to @video
  end

  def rabbithole
    @used_tags = (params[:tagged_with].presence || '').split("|")
    if (rabbit_tag = params[:add_tag]).present?
      @used_tags << rabbit_tag
      redirect_to rabbithole_videos_path(tagged_with: @used_tags.join("|"))
    elsif (rabbit_tag = params[:remove_tag]).present?
      @used_tags.delete(rabbit_tag)
      redirect_to rabbithole_videos_path(tagged_with: @used_tags.join("|"))
      
    else
      @rabbit_tags = get_rabbit_tags(@used_tags)
      # we render our view
    end
  end

  def get_rabbit_tags(used_tags)
    @videos = nil
    return if used_tags.blank?
    used_tags.each do |tag|
      if @videos.nil?
        @videos = Video.tagged_with(tag).to_a
      else
        @videos.reject!{|v| !v.tag_list.index(tag)}
      end
    end
    @tag_cloud = Hash.new(0)
    @videos.each do |v|
      v.tags.each do |tag|
        @tag_cloud[tag.name] += 1
      end
    end
  end

  def next_untagged_video
    total_ids = Video.pluck(:id)
    tagged_ids = ActsAsTaggableOn::Tagging.pluck(:taggable_id).uniq
    ids = total_ids - tagged_ids
    id = ids.sample
    if id.present?
      redirect_to Video.find(id), notice: "You have tagged #{tagged_ids.length}/#{total_ids.length} videos."
    else
      redirect_back notice: "ALL VIDEOS ALREADY TAGGED!!!", fallback_location: root_path
    end
  end

  # GET /videos or /videos.json
  def index
    if params[:tagged_with].present?
      tagged_with = params[:tagged_with].split(',')
      scope = Video
      tagged_with.each do |tag|
        scope = scope.tagged_with(tag)
      end
    else
      scope = Video.order(:filename)
    end
    @videos = scope.page(params[:page]).per(12) 
  end

  # GET /videos/1 or /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos or /videos.json
  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        format.html { redirect_to video_url(@video), notice: "Video was successfully created." }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1 or /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to video_url(@video), notice: "Video was successfully updated." }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1 or /videos/1.json
  def destroy
    @video.destroy

    respond_to do |format|
      format.html { redirect_to videos_url, notice: "Video was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def video_params
      params.require(:video).permit(:title, :file)
    end
end
