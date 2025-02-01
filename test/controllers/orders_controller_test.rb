# test/controllers/orders_controller_test.rb
require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Create sample items
    @item1 = Item.create!(
      name: "Caffè Latte",
      description: "Espresso with steamed milk",
      price: 3.50,
      tax_rate: 0.07
    )
    @item2 = Item.create!(
      name: "Donut",
      description: "Delicious glazed donut",
      price: 1.50,
      tax_rate: 0.07
    )
    # Create a promotion (if ordering a latte, discount on donut)
    @promotion = Promotion.create!(
      name: "Coffee & Donut Combo",
      discount_percentage: 0.50,
      required_item_id: @item1.id,
      discounted_item_id: @item2.id
    )
  end

  test "should create order and calculate total" do
    order_params = {
      items: [
        { item_id: @item1.id, quantity: 2 },
        { item_id: @item2.id, quantity: 1 }
      ]
    }
    post orders_url, params: order_params, as: :json
    assert_response :created

    json_response = JSON.parse(@response.body)
    assert_equal "pending", json_response["status"], "New order should have a status of pending"
    assert json_response["total_amount"].present?, "Order total should be calculated"
    assert_equal 2, json_response["order_items"].size, "There should be 2 order items"
  end

  test "should pay for order and update status" do
    # Create an order manually
    order = Order.create!(status: "pending")
    order.order_items.create!(item: @item1, quantity: 2, unit_price: @item1.price, applied_discount: 0)
    order.calculate_total
    order.save!

    # Simulate payment via the pay endpoint
    post pay_order_url(order), as: :json
    assert_response :success

    order.reload
    assert_equal "paid", order.status, "Order status should be updated to paid"
  end
end
