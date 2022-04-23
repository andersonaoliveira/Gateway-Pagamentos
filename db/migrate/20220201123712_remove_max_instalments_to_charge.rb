class RemoveMaxInstalmentsToCharge < ActiveRecord::Migration[6.1]
  def change
    remove_column :charges, :max_instalments
  end
end
