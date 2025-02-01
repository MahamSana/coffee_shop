class CreatePromotions < ActiveRecord::Migration[7.1]
  def change
    create_table :promotions do |t|
      t.string :name
      t.decimal :discount_percentage
      t.integer :required_item_id
      t.integer :discounted_item_id

      t.timestamps
    end
  end
end
