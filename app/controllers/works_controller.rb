class WorksController < ApplicationController
  before_action :set_work, only: [:edit, :update, :destroy, :thank, :like, :favorites, :reworks, :repost, :new_repost, :likes, :attachment]

  before_action :current_user, only: [:destroy, :edit_attachment,:show_attachment,:del_attachment]

  before_filter :authenticate_user!, only: [:new, :like, :unlike, :edit, :create, :update, :thank, :destroy]

  before_action :auth_block_user!, only: [:thank, :like, :repost, :new_repost]

  # GET /works
  # GET /works.json
  def index
    @works = Work.includes(:comments).all
  end

  def likes

    @users = User.joins(:works_likes).where("works_likes.work_id =?", @work.id).paginate(page: params[:page])

  end

  def favorites

    @favorite_folders = FavoriteFolder.joins(:favorites).where("favorites.work_id =?", @work.id).paginate(page: params[:page])

  end

  def reworks

    @reworks = Work.where(:parent_work_id => @work.id).paginate(page: params[:page])

  end

  def feed

    @sort = params[:sort]
    @timescope = params[:timescope]
    @is_original = params[:is_original]


    @work =current_user.works.build
    @works = current_user.work_feeds_by_fliter(@sort, @timescope, @is_original).paginate(page: params[:page])


  end

  def explore

    @domain_id = params[:domain_id]
    @tag_id = params[:tag_id]

    #1.have domain have tag
    if @domain_id && @tag_id
      @works =Work.joins(:works_tags).where("works.domain_id = ? AND works_tags.tag_id = ?", params[:domain_id], params[:tag_id]).paginate(page: params[:page])
      @tags = []

      #2.have domain no tag
    elsif @domain_id && !@tag_id
      @works =Work.where(domain_id: params[:domain_id]).paginate(page: params[:page])
      @tags = Label.joins(:works_tags).where("works_tags.work_id IN (?)", @works.map(&:id)).order("items_count DESC").limit(100)

      #3.no domain have tag
    elsif !@domain_id && @tag_id
      @works = Work.joins(:works_tags).where("works_tags.tag_id = ?", @tag_id).paginate(page: params[:page])
      @tags = []

      #4.no domain no tag
    else
      @works = Work.paginate(page: params[:page])
      @tags = Label.all.order("items_count DESC").limit(100)
    end

  end

  def hd_image
    @work = Work.find(params[:id])

    respond_to do |format|

      format.js

    end
  end

  def sd_image
    @work = Work.find(params[:id])

    respond_to do |format|

      format.js

    end
  end

  def show


    if params[:flash]=="like" && params[:timeline_user_id]
      @timeline_user = User.find(params[:timeline_user_id])
      @timeline_flash = "??????????????????."
    end

    @work = Work.includes(:comments, :user).find(params[:id])
    @is_liked = false
    @is_thanked = false

    @works_like = nil
    @thank = nil

    #set cookie fo count pv
    #set_visit_info(params[:id])
    current_user_id = nil
    ip = request.remote_ip

    if current_user
      current_user_id = current_user.id
      @works_like = WorksLike.where(user_id: current_user.id, work_id: params[:id]).first

      if @works_like
        @is_liked = true
      end

      #thank
      @thank = Thank.where(user_id: current_user.id, work_id: params[:id]).first
      if @thank
        @is_thanked = true
      end


    end

    #more work about this user
    @more_works = @work.user.user_work_recent

    pv_count(params[:id], ip, current_user_id)

    #
    @parent_work = nil
    if @work.parent_work_id != nil
      @parent_work = Work.where(id: @work.parent_work_id).first
    end

    respond_to do |format|
      format.html
      format.js

    end
  end


  # GET /works/new
  def new
    @work = current_user.works.new


    respond_to do |format|
      format.html
      format.js

    end
  end

  # GET /works/1/edit
  def edit
  end

  def attachment
    @attachment = Attachment.find(params[:aid])
  end

  def del_attachment
    attachment = Attachment.find(params[:id])

    @work = attachment.work

    attachment.destroy

    respond_to do |format|

      format.html{ redirect_to :action => "show_attachment", :id=> @work.id }
    end
  end

  def show_attachment


    @work = Work.find(params[:id])
    render :edit_attachment
  end

  def edit_attachment

    @work = Work.find(params[:id])

    @attachment = @work.attachments.new(attachment_params)
    @attachment.name = params[:attachment][:media].original_filename
    if @attachment.save
      flash[:notice] = "??????????????????????????????"
       render :edit_attachment
    else
      @work.attachments.delete(@attachment)
      render :edit_attachment
    end

  end

  def edit_tags
    @work = current_user.works.find(params[:id])
  end

  # POST /works
  # POST /works.json
  def create
    @work = current_user.works.new(work_params)

    respond_to do |format|
      if @work.save
        current_user.timelines.create(work_id: @work.id, act: "new")

        #format.html { render :edit_tags, notice: 'Work was successfully created.' }
        format.html { render :edit_attachment }
        format.json { render :show, status: :created, location: @work }
      else
        format.html { render :new }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    respond_to do |format|
      if @work.update(work_params)
        format.html { redirect_to @work, notice: '??????????????????' }
        format.json { render :show, status: :ok, location: @work }
      else
        format.html { render :edit }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy

    @work.destroy

    #destroy all notify

    respond_to do |format|
      format.html { redirect_to static_pages_home_path, notice: '??????????????????' }
      format.json { head :no_content }
    end
  end

  def build_repost
    respond_to do |format|
      format.js
    end
  end

  def new_repost
    respond_to do |format|
      format.js
    end
  end

  def repost


    @repost = current_user.works.build(work_params)

    @repost.work_type = "re"

    #@work.parent_work_id = params[:id]
    @repost.image = @work.image

    @work_id = @repost.parent_work_id

    respond_to do |format|
      if @repost.save
        #+1 repost count
        Work.increment_counter(:repost_count, @work_id)
        #timeline evetn
        current_user.timelines.create(work_id: @repost.id, act: "re")

        #notify author
        RepostWorkNotify.create(subject_id: current_user.id, obj_id: @repost.id, user_id: @work.user_id)

        format.js
      else
        format.js { render 'works/build_repost' }
      end
    end


  end

  def like

    current_user.works_likes.create(work_id: params[:id])

    #create time line
    current_user.timelines.create(work_id: params[:id], act: "like")


    LikeWorkNotify.create(subject_id: current_user.id, obj_id: params[:id], user_id: @work.user_id)
    @work = Work.find(params[:id])
    respond_to do |format|
      format.js
      format.json { render :json => {success: true} }
    end

  end

  def unlike
    like = current_user.works_likes.where(work_id: params[:id]).first
    like.destroy

    #destroy notify
    notify = LikeWorkNotify.where(subject_id: current_user.id, obj_id: params[:id]).first
    notify.destroy if notify

    #destroy timeline
    timeline = current_user.timelines.where(work_id: params[:id], act: "like").first
    timeline.destroy if timeline

    @work = Work.find(params[:id])

    respond_to do |format|
      format.js
      format.json { render :json => {success: true} }
    end

  end

  def thank

    current_user.thanks.create(work_id: params[:id])

    #notify author
    @work = Work.find(params[:id])
    ThanksWorkNotify.create(subject_id: current_user.id, obj_id: params[:id], user_id: @work.user_id)

    respond_to do |format|
      format.js
      format.json { render :json => {success: true} }
    end

  end

  def unthank
    thank = current_user.thanks.where(work_id: params[:id]).first
    thank.destroy
    @work = Work.find(params[:id])
    #destroy notify
    notify = ThanksWorkNotify.where(subject_id: current_user.id, obj_id: params[:id]).first
    notify.destroy if notify

    respond_to do |format|
      format.js
      format.json { render :json => {success: true} }
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_work
    @work = Work.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_params
    params.require(:work).permit(:title, :image, :desciption, :user_id, :views_count, :likes_count, :favorites_count, :shares_count, :is_original, :parent_work_id, :domain_id)


  end

  def attachment_params
    params.require(:attachment).permit(:media)
  end

  def pv_count(work_id, ip, user_id)


    pathname ="works/#{work_id}"
    is_can_add_count = VisitTrack.effective_pv?(pathname, ip, user_id)

    if is_can_add_count
      work = Work.find(work_id)
      work.update(views_count: work.views_count+1)
    end

  end

end