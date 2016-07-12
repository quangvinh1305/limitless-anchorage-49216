module ProductsHelper
  def newest_products
    Product.last(4).reverse
  end
end
