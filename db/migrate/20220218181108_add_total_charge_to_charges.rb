class AddTotalChargeToCharges < ActiveRecord::Migration[6.1]
  def change
    add_column :charges, :total_charge, :decimal
  end
end
