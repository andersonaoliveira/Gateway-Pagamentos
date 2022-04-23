class AddValidDateAndCpfToCreditCards < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_cards, :valid_date, :string
    add_column :credit_cards, :cpf, :string
  end
end
