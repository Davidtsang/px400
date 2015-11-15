class ReportsController < ApplicationController
  def index
  end

  def create

    if params[:type] == "CommentsReport"
      @comment_id = params[:obj_id]
      unless CommentsReport.where(obj_id: params[:obj_id], user_id: current_user.id).any?

        CommentsReport.create(obj_id: params[:obj_id], user_id: current_user.id, break_rule: params[:break_rule])

      end

      respond_to do |format|
        format.js
      end

    end

  end
end
