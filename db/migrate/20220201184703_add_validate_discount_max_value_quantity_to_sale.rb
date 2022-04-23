class AddValidateDiscountMaxValueQuantityToSale < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :expiration_date, :date
    add_column :sales, :discount, :float
    add_column :sales, :max_value, :float
    add_column :sales, :quantity, :integer
  end
end
