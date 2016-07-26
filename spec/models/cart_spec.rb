require_relative '../../config/environment'
require_relative '../rails_helper'

describe AmazonProduct do
  before :all do
    @cart = Cart.create
    @book_one = products(:ruby)
    @book_two = products(:two)
  end

  context "Add Products to Card"  do
    it "add unique prodcts" do
      @cart.add_product(@book_one.id).save!
      @cart.add_product(@book_two.id).save!
      expect(@cart.line_items.size).to eq(2)
      expect(@book_one.price + @book_two.price).to eq(@cart.total_price)
    end

    it "add duplicate product" do
      @cart.add_product(@book_one.id).save!
      @cart.add_product(@book_one.id).save!
      expect(@cart.line_items.size).to eq(1)
      expect(@cart.line_items[0].quantity).to eq(2)
    end
  end
end