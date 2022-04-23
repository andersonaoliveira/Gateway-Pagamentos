class AddCreditCardTokenToCharge < ActiveRecord::Migration[6.1]
  def change
    add_column :charges, :credit_card_token, :string
  end
end
