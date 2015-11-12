class NotificationsController < ApplicationController

  def index
    #
    @notifications   = Notification.where(user_id: current_user.id)
    @notifications
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
