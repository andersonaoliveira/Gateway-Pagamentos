class RemoveIdClientFromCharges < ActiveRecord::Migration[6.1]
  def change
    remove_column :charges, :id_client
  end
end
