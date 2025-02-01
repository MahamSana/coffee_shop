class Item < ApplicationRecord
    validates :name, :price, :tax_rate, presence: true
end
