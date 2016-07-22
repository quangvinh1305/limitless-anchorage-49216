class StaticPagesController < ApplicationController
  def home
    add_breadcrumb "Home", root_path
    @categories = Category.all
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
