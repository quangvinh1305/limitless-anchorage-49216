require_relative '../../config/environment'
require_relative '../rails_helper'

describe AmazonProduct do
  context "GetAmazonProduct"  do
    it "Can get product from amazon" do
      Product.delete_all
      AmazonProduct.new.create_amz_products
      expect(Product.count).to be > 0
    end
    it "Expect data is correct" do
      first = Product.first
      expect(first.title).to_not be_nil
      expect(first.description).to_not be_nil
      expect(first.pin).to_not be_nil
    end
  end
end