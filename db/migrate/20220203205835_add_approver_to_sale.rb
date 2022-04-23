class AddApproverToSale < ActiveRecord::Migration[6.1]
  def change
    add_reference(:sales, :approver, foreign_key: { to_table: :admins })
  end
end
