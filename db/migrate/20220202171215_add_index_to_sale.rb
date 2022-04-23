class AddIndexToSale < ActiveRecord::Migration[6.1]
  def change
    add_index :sales, :name, unique: true
  end
end
