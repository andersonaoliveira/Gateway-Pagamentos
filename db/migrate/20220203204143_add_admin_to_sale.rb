class AddAdminToSale < ActiveRecord::Migration[6.1]
  def change
    add_reference :sales, :admin, null: false, foreign_key: true
  end
end
