class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :product_id, index: true
      t.integer :cart_id, index: true
      t.integer :quantity, default: 1
      t.integer :order_id, index: true

      t.timestamps null: false
    end
  end
end
