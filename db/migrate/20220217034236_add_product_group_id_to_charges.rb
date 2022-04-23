class AddProductGroupIdToCharges < ActiveRecord::Migration[6.1]
  def change
    add_column :charges, :product_group_id, :string
  end
end
