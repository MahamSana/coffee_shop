# test/models/order_test.rb
require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    # Create two items with tax rates
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
    # Create a promotion: if you order a Caffè Latte, you get a 50% discount on a Donut.
    @promotion = Promotion.create!(
      name: "Coffee & Donut Combo",
      discount_percentage: 0.50,
      required_item_id: @item1.id,
      discounted_item_id: @item2.id
    )
  end

  test "calculate total for order with discount and tax" do
    order = Order.new(status: "pending")
    # Add 2 lattes at full price
    order.order_items.build(
      item: @item1,
      quantity: 2,
      unit_price: @item1.price,
      applied_discount: 0
    )
    # Add 1 donut with discount applied
    discounted_price = @item2.price * (1 - @promotion.discount_percentage)
    order.order_items.build(
      item: @item2,
      quantity: 1,
      unit_price: discounted_price,
      applied_discount: @item2.price - discounted_price
    )

    order.calculate_total

    # Expected Calculation:
    # Lattes: 2 x 3.50 = 7.00, Tax = 7.00 * 0.07 = 0.49, Total = 7.49
    # Donut: 1 x discounted_price = 0.75, Tax = 0.75 * 0.07 ≈ 0.0525, Total ≈ 0.8025
    expected_total = 7.00 + 0.49 + 0.75 + 0.0525

    # Allow for floating point differences with a delta
    assert_in_delta expected_total, order.total_amount, 0.001, "Order total should include proper tax and discount"
  end
end
