class CreateCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :charges do |t|
      t.integer :id_order
      t.string :token
      t.integer :max_instalments

      t.timestamps
    end
  end
end
