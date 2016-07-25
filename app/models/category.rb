class Category < ActiveRecord::Base
  CATEGORIES = { "Arts & Photography" => "1",
                 "History" => "9",
                 "Literature & Fiction" => "17",
                 "Science & Math" => "75",
                 "Computers & Technology" => "5" }

  def self.get_categories
    results = {}
    category_records = Category.select(:id, :title)
    category_records.each do |category|
      results[category.title] = category.id
    end
    results
  end

  has_many :products
  has_many :included_products, -> { limit(7) }, :class_name => 'Product'
  def decorate
    @decorate ||= CategoryDecorator.new self
  end
end
