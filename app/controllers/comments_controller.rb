class CommentsController < ApplicationController

  before_action :authenticate_user!, only: [:like ,:create, :unlike , :remove]

  def index
    work_id = params[:work_id]

    @comments  = Comment.includes(:user).where(work_id: work_id)


    respond_to do |format|

      format.js

    end
  end
  def show
  end

  #create
  def like

    current_user.comments_likes.create(comment_id: params[:id])
    @comment = Comment.find(params[:id])
    respond_to do |format|

      format.js

    end

  end

  def unlike
    like = current_user.comments_likes.where(comment_id: params[:id]).first
    like.destroy

    @comment = Comment.find(params[:id])
    respond_to do |format|

      format.js

    end
  end

  def remove

    #just current_user or admin or commit suer can del
    @comment_id = params[:id]
    comment =Comment.find(@comment_id)
    #
    # #del notify author first
    # notify = CommentsWorkNotify.where(subject_id: comment.user_id, obj_id: comment.id ).first
    # notify.destroy if notify
    #
    # if comment.parent_id
    #   reply_notify = ReplyCommentNotify.where(subject_id: comment.user_id, obj_id: comment.id ).first
    #   reply_notify.destroy if reply_notify
    #
    # end

    comment.destroy

    respond_to do |format|
      format.js

    end

  end

  def new

    @parent_id = params[:parent_id]
    comment = Comment.find(@parent_id)
    @work_id = comment.work.id

    respond_to do |format|
      format.js

    end

  end
  def create
    #work_id = params[:id]
    @parent_id = comments_params[:parent_id]


    comment = current_user.comments.create(comments_params)

    #notify author
    work = Work.find(comments_params[:work_id])
    unless @parent_id
    CommentsWorkNotify.create(subject_id: current_user.id, obj_id: comment.id , user_id: work.user_id)
    else
      parent_comment = Comment.where(id: @parent_id).first
    ReplyCommentNotify.create(subject_id: current_user.id, obj_id: comment.id , user_id: parent_comment.user_id)
    end

    respond_to do |format|

      format.js { redirect_to comments_path(work_id: comments_params[:work_id] ) ,format: 'js'}

    end
  end

  private

  def comments_params
    params.require(:comment).permit([:content, :work_id, :user_id, :parent_id])
  end
end
