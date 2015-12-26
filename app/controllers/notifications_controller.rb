class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index

    @notifications   = Notification.where(user_id: current_user.id).paginate(page: params[:page])
    @uncheck_notice_count = Notification.where(user_id: current_user.id, is_checked: false ).paginate(page: params[:page]).count
    if @uncheck_notice_count > 0
      Notification.where(id: @notifications.map(&:id)).update_all(is_checked: true)
    end
    respond_to do |format|
      format.html
      format.js

    end
  end

  def remote_notice_data

    @notifications   = Notification.where(user_id: current_user.id).limit(32)
    Notification.where(id: @notifications.map(&:id)).update_all(is_checked: true)
    render layout: false
  end

  #ajax check notify
  def mark_checked

    notification  = Notification.find(params[:id])

    notification.is_checked = true

    notification.save

    respond_to do |format|

      format.js

    end


  end
end
