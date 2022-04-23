class AddColumnsToCharges < ActiveRecord::Migration[6.1]
  def change
    add_column :charges, :product_group_id, :integer
    add_column :charges, :order_value, :decimal, :precision => 8, :scale => 2
    add_column :charges, :cupom_code, :string
    add_column :charges, :client_eni, :string
  end
end
