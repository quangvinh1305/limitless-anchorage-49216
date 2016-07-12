module OrdersHelper
  def send_order_email(order)
    h = JSON.generate({'email' => order.email, 'order_id'=> order.id})
    OrderWorker.perform_async(h, 5)
  end
end
