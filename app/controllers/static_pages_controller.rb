class StaticPagesController < ApplicationController


  layout "base", only: [:about, :about_icode]
  def home

  sort = params[:sort]
  timescope = params[:timescope]
  feed_type = params[:feed_type]

    if user_signed_in?
      @work =current_user.works.build

      if sort || feed_type #to work
        redirect_to feed_works_path(timescope: timescope, feed_type: feed_type)
      else
        @feed_items = current_user.feed.paginate(page: params[:page])
      end
    else
      @works  = Work.order("works_likes_count DESC").limit(20)


    end
  end


  def about_icode

  end

  def about
  end
end
