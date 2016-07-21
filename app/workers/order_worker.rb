class OrderWorker
  include Sidekiq::Worker
  def perform(id)
    OrderNotifier.received(id).deliver_now
  end
end