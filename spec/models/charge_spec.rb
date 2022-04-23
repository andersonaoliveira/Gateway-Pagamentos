require 'rails_helper'

RSpec.describe Charge, type: :model do
  context 'fields invalid' do
    it 'id order string' do
      charge = Charge.new(id_order: 'a', client_eni: '11122233345', qty_instalments: 6,
                          credit_card_token: 'CAMPUSCODELOCAWEBQSD')

      result = charge.valid?

      expect(result).to eq false
    end

    it 'id client string' do
      charge = Charge.new(id_order: 1, client_eni: 11_122_233_345, qty_instalments: 6,
                          credit_card_token: 'CAMPUSCODELOCAWEBQSD')

      result = charge.valid?

      expect(result).to eq false
    end

    it 'quantity instalments float' do
      charge = Charge.new(id_order: 1, client_eni: '11122233345', qty_instalments: 1.5,
                          credit_card_token: 'CAMPUSCODELOCAWEBQSD')

      result = charge.valid?

      expect(result).to eq false
    end

    it 'token format' do
      charge = Charge.new(id_order: 1, client_eni: '11122233345', qty_instalments: 4,
                          credit_card_token: 'CAMPUSCODELOCAWEB')

      result = charge.valid?

      expect(result).to eq false
    end
  end
end
