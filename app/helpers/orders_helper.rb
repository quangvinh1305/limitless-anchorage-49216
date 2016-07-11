module OrdersHelper
  def send_order_email(order)
    OrderNotifier.received(order).deliver
  end
end
