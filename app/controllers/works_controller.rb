class WorksController < ApplicationController
  before_action :set_work, only: [:show, :edit, :update, :destroy]
  before_action :current_member, only: :destroy

  before_filter :authenticate_user!, only: [:like, :unlike, :edit, :create, :update, :thank]

  def like

    current_user.works_likes.create(work_id: params[:id])


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

  # GET /works
  # GET /works.json
  def index
    @works = Work.all
  end


  def show
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
  end
end


# GET /works/new
def new
  @work = Work.new
end

# GET /works/1/edit
def edit
end

# POST /works
# POST /works.json
def create
  @work = current_user.works.new(work_params)

  respond_to do |format|
    if @work.save
      format.html { redirect_to @work, notice: 'Work was successfully created.' }
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

private
# Use callbacks to share common setup or constraints between actions.
def set_work
  @work = Work.find(params[:id])
end

# Never trust parameters from the scary internet, only allow the white list through.
def work_params
  params.require(:work).permit(:title, :image, :desciption, :user_id, :views_count, :likes_count, :favorites_count, :shares_count)


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
    VisitTrack.renew(pathname,ip,user_id)

  end

end