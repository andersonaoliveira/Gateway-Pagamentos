class AddIndexToCreditCard < ActiveRecord::Migration[6.1]
  def change
    add_index :credit_cards, :number, unique: true
    add_index :credit_cards, :token, unique: true
  end
end
