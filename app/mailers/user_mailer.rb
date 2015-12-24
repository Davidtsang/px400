class UserMailer < ApplicationMailer

  default from: 'no-reply@400px.net'

  def welcome_email(user)

    @user = user
    @url = "https://www.400px.net/sign_in"
    mail(to: @user.email, subject: "欢迎加入400px.net --- 中国设计师与艺术家的社交平台")
  end
end
