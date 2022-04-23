class AddProductGroupIdToSale < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :product_group_id, :integer
  end
end
