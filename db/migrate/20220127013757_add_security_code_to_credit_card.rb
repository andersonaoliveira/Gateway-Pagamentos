class AddSecurityCodeToCreditCard < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_cards, :security_code, :string
  end
end
