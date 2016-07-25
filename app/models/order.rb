class Order < ActiveRecord::Base
  PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]
  SHIPPING_STATUS = %w{New Preparing Shipping Done Cancel Refund}
  SHIPPING_STATUS_MAP = { "New" => "0",
                 "Preparing" => "1",
                 "Shipping" => "2",
                 "Done" => "3",
                 "Cancel" => "4",
                 "Refund" => "5" }
  has_many :line_items, dependent: :destroy
  # ...
  validates :name, :address, :email, :phone_number, presence: true
  belongs_to :users
  validates :pay_type, inclusion: PAYMENT_TYPES
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end


  def remove_product_in_stock
    line_items.each do |item|
      product = item.product
      product.stock -= item.quantity
      product.save
    end
  end
end
