# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Create some items
coffee = Item.create!(name: "Caffè Latte", description: "Espresso with steamed milk", price: 3.50, tax_rate: 0.07)
donut = Item.create!(name: "Donut", description: "Delicious glazed donut", price: 1.50, tax_rate: 0.07)
mug = Item.create!(name: "Coffee Mug", description: "Ceramic mug", price: 5.00, tax_rate: 0.07)

# Create a promotion: if a customer buys a coffee, they get a discount on a donut.
Promotion.create!(name: "Coffee & Donut Combo", discount_percentage: 0.50, required_item_id: coffee.id, discounted_item_id: donut.id)
