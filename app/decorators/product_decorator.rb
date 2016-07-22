class ProductDecorator < BaseDecorator

  def link
    helpers.link_to "#{@component.title.truncate(30, separator: ' ')}", routes.product_path(@component)
  end

end