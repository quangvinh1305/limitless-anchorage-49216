class StaticPagesController < ApplicationController
  def home
    @categories = Category.all
    if logged_in?
      #debugger
      
      # @micropost  = current_user.microposts.build
      # @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
