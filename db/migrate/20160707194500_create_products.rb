class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :image
      t.decimal :price, :precision => 8, :scale => 2
      t.string :pin

      t.timestamps null: false
    end
  end
end
