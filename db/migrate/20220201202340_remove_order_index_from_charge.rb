class RemoveOrderIndexFromCharge < ActiveRecord::Migration[6.1]
  def change
    remove_index :charges, :id_order, unique: true
  end
end
