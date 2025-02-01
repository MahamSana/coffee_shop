class Order < ApplicationRecord
    has_many :order_items, dependent: :destroy

    # Calculate the total amount based on order_items.
    def calculate_total
      self.total_amount = order_items.sum do |oi|
        # Each order item: unit_price * quantity plus tax.
        item_total = oi.unit_price * oi.quantity
        tax = item_total * oi.item.tax_rate
        item_total + tax
      end
    end
end
