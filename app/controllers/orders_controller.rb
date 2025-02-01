class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /orders
  def create
    order = Order.new(status: 'pending')
    items_params = params.require(:items)
    # items_params should be an array of objects: [{item_id: 1, quantity: 2}, ...]

    items_params.each do |item_data|
      item = Item.find(item_data[:item_id])
      quantity = item_data[:quantity].to_i
      # Set the initial unit_price
      unit_price = item.price

      # Find any promotion that applies for this item (discounted_item) if required item is also present.
      promo = Promotion.find_by(discounted_item_id: item.id)
      if promo && items_params.any? { |i| i[:item_id].to_i == promo.required_item_id }
        unit_price = unit_price * (1 - promo.discount_percentage)
      end

      order.order_items.build(item: item, quantity: quantity, unit_price: unit_price, applied_discount: (item.price - unit_price))
    end

    # Calculate total (including tax)
    order.calculate_total
    if order.save
      render json: order, include: :order_items, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  # GET /orders/:id
  def show
    order = Order.find(params[:id])
    render json: order, include: :order_items
  end

  # POST /orders/:id/pay
  def pay
    order = Order.find(params[:id])
    if order.status != 'pending'
      render json: { error: "Order cannot be paid" }, status: :unprocessable_entity and return
    end

    # Simulate payment processing.
    order.status = 'paid'
    order.paid_at = Time.current
    order.save!

    # Enqueue a job to mark order complete after a fixed delay (e.g., 30 seconds).
    OrderCompletionJob.set(wait: 30.seconds).perform_later(order.id)

    render json: order, status: :ok
  end
end
