class StaticPagesController < ApplicationController
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

    end
  end

  def about
  end
end
