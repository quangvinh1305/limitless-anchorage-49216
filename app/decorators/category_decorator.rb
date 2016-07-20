class CategoryDecorator < BaseDecorator

  def link
    h.link_to @component.title.upcase, r.category_path(@component)  
  end

end