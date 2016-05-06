class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]
  after_action :send_welcome_mail , only: [:create]

  layout 'base', :only => [:new, :create]
  def block_list
    @user = current_user
    @blacklists = current_user.blacklists.all

  end

  def icodes
    @user = current_user

  end

  def notice_settings
    @user = current_user
  end

  def profile
    @user = current_user
  end

  def update_profile

    @user = User.find(current_user.id)
    if @user.update(users_params)
      flash[:notice] ="你已经成功更新了一般设置"
    end

    redirect_to '/home'

  end

  def update_avatar
    @user = User.find(current_user.id)
    if @user.update(users_params)
      flash[:notice] ="你已经成功更新了头像"
    end

    render :'devise/registrations/edit'
  end

  # GET /resource/sign_up
  def new
    @icode = params[:icode]
    super
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

   protected

  def send_welcome_mail
    UserMailer.welcome_email(resource).deliver_now
  end
  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << [:icode, :name]
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) << [:name, :nickname, :sex, :title, :company, :location]
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
    profile_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  def users_params
    params.require(:user).permit([:title, :bio, :company, :sex, :location, :website, :avatar, :domain_1_id, :domain_2_id, :is_allow_notice_mail])
  end
end
