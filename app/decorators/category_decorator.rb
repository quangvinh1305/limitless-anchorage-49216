class CategoryDecorator < BaseDecorator

  def link
    helpers.link_to @component.title.upcase, routes.category_path(@component)
  end

end