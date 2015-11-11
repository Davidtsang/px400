class WorksController < ApplicationController
  before_action :set_work, only: [:edit, :update, :destroy]
  before_action :current_member, only: :destroy

  before_filter :authenticate_user!, only: [:new, :like, :unlike, :edit, :create, :update, :thank]


  # GET /works
  # GET /works.json
  def index
    @works = Work.includes(:comments).all
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
      @tags = Label.joins(:works_tags).where("works_tags.work_id IN (?)", @works.map(&:id)).order("items_count DESC")

      #3.no domain have tag
    elsif !@domain_id && @tag_id
      @works = Work.joins(:works_tags).where("works_tags.tag_id = ?", @tag_id).paginate(page: params[:page])
      @tags = []

      #4.no domain no tag
    else
      @works = Work.paginate(page: params[:page])
      @tags = Label.all.order("items_count DESC")
    end

  end

  def show
    if params[:flash]=="like" && params[:timeline_user_id]
      @timeline_user = User.find(params[:timeline_user_id])
      @timeline_flash = "赞了这个帖子."
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

    #view count
    #set cookie
    pv_count(params[:id], ip, current_user_id)

    #
    @parent_work = nil
    if @work.parent_work_id != nil
      @parent_work = Work.find(@work.parent_work_id)
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

  def add_tag

  end

  # POST /works
  # POST /works.json
  def create
    @work = current_user.works.new(work_params)

    respond_to do |format|
      if @work.save
        current_user.timelines.create(work_id: @work.id, act: "new")

        format.html { render :add_tag, notice: 'Work was successfully created.' }
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
        format.html { redirect_to @work, notice: 'Work was successfully updated.' }
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
    respond_to do |format|
      format.html { redirect_to works_url, notice: 'Work was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def repost
    @work_id = params[:id]
    @work = Work.find(@work_id)

    @repost = current_user.works.build(work_params)

    @repost.work_type = "re"

    #@work.parent_work_id = params[:id]
    @repost.image = @work.image


    respond_to do |format|
      if @repost.save
        #+1 repost count
        Work.increment_counter(:repost_count, @work_id)
        #timeline evetn
        current_user.timelines.create(work_id: @repost.id, act: "re")

        format.js
      else
        format.js { render 'works/new_repost' }
      end
    end


  end

  def like

    current_user.works_likes.create(work_id: params[:id])

    #create time line
    current_user.timelines.create(work_id: params[:id], act: "like")
    respond_to do |format|
      #format.html { redirect_to designers_all_path }
      format.json { render :json => {success: true} }
    end

  end

  def unlike
    like = current_user.works_likes.where(work_id: params[:id]).first
    like.destroy

    respond_to do |format|
      #format.html { redirect_to designers_all_path }
      format.json { render :json => {success: true} }
    end

  end

  def thank

    current_user.thanks.create(work_id: params[:id])


    respond_to do |format|
      #format.html { redirect_to designers_all_path }
      format.json { render :json => {success: true} }
    end

  end

  def unthank
    thank = current_user.thanks.where(work_id: params[:id]).first
    thank.destroy

    respond_to do |format|
      #format.html { redirect_to designers_all_path }
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

  def path_ip_can_add_count?(pathname, ip)
    vs = VisitTrack.where(visit_path: pathname, ip: ip).first
    is_can_add_count = false
    if vs #yes, check data if > 6 h , is new visit
      if vs.visit_time < (Time.now - 6.hours)
        is_can_add_count = true
      end
    else # if no record?
      is_can_add_count = true
    end

    is_can_add_count

  end

  def path_user_can_add_count?(pathname, user_id)
    is_can_add_count = false
    #2user visit this page?
    vs = VisitTrack.where(visit_path: pathname, user_id: user_id).first


    if vs #yes, check data if > 6 h , is new visit
      if vs.visit_time < (Time.now - 6.hours)
        is_can_add_count = true
      end
    else # if no record?
      is_can_add_count = true
    end

    is_can_add_count
  end

  def pv_count(work_id, ip, user_id)
    #GET RECODRD

    is_can_add_count = false

    pathname ="works/#{work_id}"

    #1 if have user id ,this member visit
    if user_id
      is_can_add_count = path_user_can_add_count?(pathname, user_id)

    else #not user_id , check ip
      is_can_add_count =path_ip_can_add_count?(pathname, ip)

    end

    #renew vs


    #work count +1
    if is_can_add_count
      work = Work.find(work_id)
      work.update(views_count: work.views_count+1)

      #renew vs
      VisitTrack.renew(pathname, ip, user_id)

    end

  end
end