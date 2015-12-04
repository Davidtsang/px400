class ReportsController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def create

    @obj_id = params[:obj_id]
    if params[:type] == "CommentsReport"

      unless CommentsReport.where(obj_id: params[:obj_id], user_id: current_user.id).any?

        CommentsReport.create(obj_id: params[:obj_id], user_id: current_user.id, break_rule: params[:break_rule])

      end

    elsif params[:type] == "MessagesReport"

      unless MessagesReport.where(obj_id: params[:obj_id], user_id: current_user.id).any?

        MessagesReport.create(obj_id: params[:obj_id], user_id: current_user.id, break_rule: params[:break_rule])

      end


    end

    respond_to do |format|
      format.js
    end
  end
end
