class Category < ActiveRecord::Base
  #CATEGORIES_ARRAY = [ "Arts & Photography", "History", "Literature & Fiction", "Science & Math", "Computers & Technology"]
  
  CATEGORIES = { "Arts & Photography" => "1",
                 "History" => "9",
                 "Literature & Fiction" => "17",
                 "Science & Math" => "75",
                 "Computers & Technology" => "5" }

  def self.get_categories
    Category.select(:id, :title).all
  end

  has_many :products
  has_many :included_products, -> { limit(5) }, :class_name => 'Product'
  def decorate
    @decorate ||= CategoryDecorator.new self
  end
end
