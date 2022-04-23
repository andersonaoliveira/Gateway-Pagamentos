require 'rails_helper'

describe 'Admin view home page' do
  it 'successfully' do
    admin = create(:admin, email: 'teste@locaweb.com.br')
    Sale.create!(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                 product_group_id: 1, max_value: 200, admin: admin)
    Sale.create!(name: 'BlackFriday', expiration_date: '30/11/2022', discount: 20, quantity: 80,
                 product_group_id: 2, max_value: 300, admin: admin, status: :approved)
    Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022', discount: 40, quantity: 90,
                 product_group_id: 1, max_value: 100, admin: admin)
    Sale.create!(name: 'Pascoa', expiration_date: '12/06/2022', discount: 40, quantity: 90,
                 product_group_id: 1, max_value: 100, admin: admin)
    Sale.create!(name: 'Dia dos Namorados', expiration_date: '12/11/2022', discount: 40, quantity: 90,
                 product_group_id: 1, max_value: 100, admin: admin)
    allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                 .and_return 'CAMPUSCODELOCAWEBQSD'
    create(:card_banner)
    create(:credit_card)
    create(:charge, id_order: 125, credit_card_token: 'CAMPUSCODELOCAWEBQSD')
    c2 = create(:charge, id_order: 789, credit_card_token: 'CAMPUSCODELOCAWEBQSD')
    create(:charge, id_order: 486, credit_card_token: 'CAMPUSCODELOCAWEBQSD')
    create(:charge, id_order: 522, credit_card_token: 'CAMPUSCODELOCAWEBQSD')
    create(:charge, id_order: 658, credit_card_token: 'CAMPUSCODELOCAWEBQSD')
    c2.approved!

    login_as admin
    visit root_path

    expect(page).to have_css 'h1', text: 'GATEWAY DE PAGAMENTOS'
    expect(page).to have_css 'h2', text: 'PENDÊNCIAS'
    expect(page).to have_css 'h2', text: 'Promoções Pendentes'
    expect(page).to have_css 'h2', text: 'Cobranças Pendentes'
    expect(page).to have_css 'th', text: 'Data de Validade'
    expect(page).to have_css 'th', text: 'Nome da Promoção'
    expect(page).to have_css 'td', text: 'NatalIluminado'
    expect(page).to have_css 'td', text: 'BoraGastar'
    expect(page).to have_css 'td', text: 'Pascoa'
    expect(page).to have_css 'td', text: '25/12/2022'
    expect(page).to have_css 'td', text: '12/10/2022'
    expect(page).to have_css 'td', text: '12/06/2022'
    expect(page).to have_css 'th', text: 'Ordem de Cobrança'
    expect(page).to have_css 'th', text: 'Número do Pedido'
    expect(page).to have_css 'th', text: 'CPF do Cliente'
    expect(page).to have_css 'td', text: '125'
    expect(page).to have_css 'td', text: '522'
    expect(page).to have_css 'td', text: '486'
    expect(page).to have_css 'td', text: '1'
    expect(page).to have_css 'td', text: '3'
    expect(page).to have_css 'td', text: '4'
    expect(page).not_to have_css 'td', text: 'BlackFriday'
    expect(page).not_to have_css 'td', text: 'Dia dos Namorados'
    expect(page).not_to have_css 'td', text: '658'
    expect(page).not_to have_css 'td', text: '789'
  end
end
