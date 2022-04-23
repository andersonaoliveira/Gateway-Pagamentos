class RemoveTokenFromCharge < ActiveRecord::Migration[6.1]
  def change
    remove_column :charges, :token
  end
end
