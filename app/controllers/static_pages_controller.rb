class StaticPagesController < ApplicationController
  def home
    @categories = Category.includes(:products).all
  end

  def help
  end

  def about
  end

  def contact
  end

end
