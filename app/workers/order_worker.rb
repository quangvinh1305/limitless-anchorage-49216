class OrderWorker
  include Sidekiq::Worker
  def perform(id, h)
    OrderNotifier.received(id).deliver_now
  end
end