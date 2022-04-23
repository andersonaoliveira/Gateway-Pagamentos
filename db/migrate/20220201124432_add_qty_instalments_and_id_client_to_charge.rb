class AddQtyInstalmentsAndIdClientToCharge < ActiveRecord::Migration[6.1]
  def change
    add_column :charges, :qty_instalments, :integer
    add_column :charges, :id_client, :integer
  end
end
