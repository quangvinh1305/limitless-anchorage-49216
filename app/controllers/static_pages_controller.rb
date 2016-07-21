class StaticPagesController < ApplicationController
  def home
    @categories = Category.includes(:included_products)
  end

  def help
  end

  def about
  end

  def contact
  end

end
