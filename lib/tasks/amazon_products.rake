namespace :venshop do
  desc "Create categories"
  task create_categories: :environment do
    Category::CATEGORIES.each do |category, br_node|
      Category.create(title: category)
      puts "#{category} is created"
    end
  end

  desc "Update products from Amazon"
  task update_amazon: :environment do
    AmazonProduct.new.create_amz_products
  end

  desc "Update stock for product"
  task update_stock: :environment do
    products = Product.select { |p| p.stock <= 0 }
    products.each { |product| product.update(stock: rand(1..20)) }
  end
end
