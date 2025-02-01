class Promotion < ApplicationRecord
    # A promotion applies when a required_item is in the order.
    # It gives a discount on the discounted_item.
    belongs_to :required_item, class_name: "Item"
    belongs_to :discounted_item, class_name: "Item"
end
