require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  it 'valid date expirated' do
    c1 = CardBanner.create!(name: 'Visa', max_instalments: 12, discount: 8,
                            percentual_tax: 10, max_tax: 10)
    cc = CreditCard.new(holder_name: 'Pedro de Lara', cpf: '11111111111',
                        card_banner_id: c1.id, number: '4444555566667777',
                        valid_date: '2021-01', security_code: '222')

    result = cc.valid?

    expect(result).to eq false
  end

  it 'successfull' do
    c1 = CardBanner.create!(name: 'Visa', max_instalments: 12, discount: 8,
                            percentual_tax: 10, max_tax: 10)
    cc = CreditCard.new(holder_name: 'Pedro de Lara', cpf: '11111111111',
                        card_banner_id: c1.id, number: '4444555566667777',
                        valid_date: '2023-01', security_code: '222')
    cc.save

    expect(cc.token).not_to eq nil
    expect(cc.token.length).to eq 20
  end
end
