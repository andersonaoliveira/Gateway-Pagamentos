class AddIndexToCharge < ActiveRecord::Migration[6.1]
  def change
    add_index :charges, :id_order, unique: true
  end
end
