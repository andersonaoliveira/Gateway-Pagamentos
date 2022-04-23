class AddReturnToCharge < ActiveRecord::Migration[6.1]
  def change
    add_column :charges, :return, :string
  end
end
