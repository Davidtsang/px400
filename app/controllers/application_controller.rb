class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def auth_block_user!

    if @work
      user = @work.user
    else
      user = @user
    end

    if user.blocked?(current_user.id)

      respond_to do |format|
        format.js { render text: "由于用户设置，你无法进行此项操作", status: :method_not_allowed }
        format.html { render 'shared/_auth_block_user' }
        format.json { render text: "由于用户设置，你无法进行此项操作", status: :method_not_allowed }

      end

      return false

    end
  end

  def current_user_is_admin
    if current_user && current_user.user_role == "admin"
      return current_user
    else
      return nil
    end
  end

end
