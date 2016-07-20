class OrderWorker
  include Sidekiq::Worker
  def perform(id, count)
    
    OrderNotifier.received(id).deliver_now
  end
end