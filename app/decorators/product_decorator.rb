class ProductDecorator < BaseDecorator

  def link
    h.link_to "#{@component.title.truncate(30, separator: ' ')}", r.product_path(@component)  
  end

end