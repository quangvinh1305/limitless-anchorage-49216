class StaticPagesController < ApplicationController
  def home
    add_breadcrumb "Home", root_path
    @categories = Category.all
    if logged_in?

      # @micropost  = current_user.microposts.build
      # @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
    add_breadcrumb "Home", root_path
    add_breadcrumb "Help"
  end

  def about
  end

  def contact
  end

end
