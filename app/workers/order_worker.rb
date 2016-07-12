class OrderWorker
  include Sidekiq::Worker
  def perform(h, count)
    h = JSON.load(h)
    OrderNotifier.received(h['email'], h['order_id']).deliver_now
  end
end