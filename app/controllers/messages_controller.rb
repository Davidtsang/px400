class MessagesController < ApplicationController
  def index
    @messages = current_user.receive_messages.all

  end

  def show
    @message = current_user.receive_messages.find(params[:id])
    if @message.is_read == false
      @message.is_read = true
      @message.save

    end
  end

  def sent
    @messages = current_user.send_messages.all

  end

  def show_sent
    @message = current_user.send_messages.find(params[:id])
  end

  def new

    @message  = current_user.send_messages.new(to_user_id: params[:to_user_id])
    @message.to_user_id = params[:to_user_id]

  end

  def create

    @message  = current_user.send_messages.new(message_params)
    @message.is_read = false

    if @message.save
      respond_to do |format|
        format.html
      end

    else

      respond_to do |format|
        format.html { render :new }
      end
    end

  end

  def disable_show
    @message = current_user.receive_messages.find(params[:id])

    @message.status = Message::MSG_STATUS_RECEIVER_NO_DISPLAY
    @message.save

    respond_to do |format|
      format.html{
        flash[:notice] ="操作已完成."
        redirect_to sent_messages_path
      }
    end
  end

  def destroy
    @message  = current_user.send_messages.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html {
        flash[:notice] ="此条私信已销毁."
        redirect_to sent_messages_path
      }
    end
  end
  private

  def message_params
    params.require(:message).permit([:to_user_id, :from_user_id, :content, :status ] )
  end
end
