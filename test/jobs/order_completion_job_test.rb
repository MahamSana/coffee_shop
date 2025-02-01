# test/jobs/order_completion_job_test.rb
require "test_helper"

class OrderCompletionJobTest < ActiveJob::TestCase
  test "order completion job updates order status" do
    order = Order.create!(status: "paid")
    # Execute the job immediately
    OrderCompletionJob.perform_now(order.id)
    order.reload
    assert_equal "completed", order.status, "Order status should be updated to completed by the job"
  end
end
