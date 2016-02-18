class UserMailer < ApplicationMailer

  default from: 'no-reply@mg.400px.net'

  def welcome_email(user)

    @user = user
    @url = "http://www.400px.cn/sign_in"
    mail(to: @user.email, subject: "欢迎加入400px.cn --- 中国设计师与艺术家的社交平台")
  end

  def daily_notice_email(user, new_notice_count, new_pm_count)

    @user = user
    #count unread notice number


    @new_notice_str =""
    if new_notice_count > 0
      @new_notice_str = "#{new_notice_count}条新的通知"

    end

    @new_pm_str = ""
    if new_pm_count > 0
      @new_pm_str = "#{new_pm_count}条新的私信"
    end

    mail(to: @user.email, subject: "你有#{@new_notice_str}#{@new_pm_str} --- 400px.net")

  end

end
