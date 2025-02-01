class OrderCompletionJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(order_id)
    # Mark the order as completed
    order.status = 'completed'
    order.save!

    # Simulate notification (e.g., logging)
    Rails.logger.info "Notification: Order ##{order.id} is now complete and ready for pickup!"
  end
end
