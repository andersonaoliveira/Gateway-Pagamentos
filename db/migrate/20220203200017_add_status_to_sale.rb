class AddStatusToSale < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :status, :integer, default: 0
  end
end
