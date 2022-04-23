require 'rails_helper'

describe 'Admin view a charge details' do
  it 'successfully' do
    allow(SecureRandom).to receive(:alphanumeric).with(20).and_return 'CAMPUSCODELOCAWEBQSD'
    allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
    adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
    adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
    product_groups = []
    product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups << product_group
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)
    bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                               discount: 40, quantity: 2, product_group_id: 'EMAIL',
                               max_value: 100, admin: adm1, status: :approved,
                               approver: adm2)
    bora_gastar.generate_coupons
    create(:card_banner)
    create(:credit_card)
    create(:charge, cupom_code: 'BORAGASTAR-ZZZZZZ')
    charge = create(:charge, id_order: 789, credit_card_token: 'CAMPUSCODELOCAWEBQSD',
                             qty_instalments: 4, client_eni: '33322233345',
                             product_group_id: 'EMAIL', order_value: 1000.0,
                             cupom_code: 'BORAGASTAR-ZZZZZZ')

    login_as adm1
    visit root_path
    click_on 'Visualizar Cobranças'
    click_on charge.id.to_s

    expect(page).to have_css 'h1', text: 'DETALHES DA COBRANÇA #2'
    expect(page).to have_css 'strong', text: charge.id_order.to_s
    expect(page).to have_css 'b', text: 'EMAIL'
    expect(page).to have_css 'b', text: charge.client_eni.to_s
    expect(page).to have_css 'b', text: charge.credit_card_token.to_s
    expect(page).to have_css 'b', text: 'R$ 900,00'
    expect(page).to have_css 'b', text: charge.cupom_code.to_s
    expect(page).to have_css 'b', text: '4x de R$ 225,00'
  end
end
