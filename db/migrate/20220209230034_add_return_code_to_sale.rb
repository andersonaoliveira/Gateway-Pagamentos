class AddReturnCodeToSale < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :return_code, :string
  end
end
