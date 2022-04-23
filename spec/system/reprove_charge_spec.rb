require 'rails_helper'
api_domain = Rails.configuration.apis['clients_api']
describe 'Admin reprove a charge' do
  it 'successfully' do
    adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
    adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
    product_groups = []
    product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups << product_group
    bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                               discount: 40, quantity: 2, product_group_id: product_group.key,
                               max_value: 100, admin: adm1, status: :approved,
                               approver: adm2)

    allow(SecureRandom).to receive(:alphanumeric).with(20).and_return 'CAMPUSCODELOCAWEBQSD'
    allow(SecureRandom).to receive(:hex).and_return '904778'
    allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')

    coupon = Coupon.create!(sale_id: bora_gastar.id)
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)
    create(:card_banner)
    create(:credit_card)
    charge = create(:charge, id_order: 350, credit_card_token: 'CAMPUSCODELOCAWEBQSD',
                             qty_instalments: 4, client_eni: '33322233345',
                             product_group_id: product_group.key, order_value: 1000.0, cupom_code: 'BORAGASTAR-ZZZZZZ')
    charge_body = File.read(Rails.root.join('spec', 'support', 'api_resources', 'charge_approved.json'))
    response = Faraday::Response.new(status: 200, response_body: charge_body)
    allow(Faraday).to receive(:patch).with("#{api_domain}/api/v1/orders/payment").and_return(response)

    login_as adm1
    visit charges_path
    click_on charge.id.to_s
    click_on 'Reprovar'
    select '15 - Banco emissor indisponível ou inexistente.'
    click_on 'Salvar'

    expect(coupon.status).to include 'unused'
    expect(current_path).to eq charge_path(charge.id)
    expect(page).to have_css 'h1', text: 'DETALHES DA COBRANÇA #1'
    expect(page).to have_css 'strong', text: charge.id_order.to_s
    expect(page).to have_css 'b', text: 'EMAIL'
    expect(page).to have_css 'b', text: charge.client_eni.to_s
    expect(page).to have_css 'b', text: charge.credit_card_token.to_s
    expect(page).to have_css 'b', text: 'R$ 1.000,00'
    expect(page).to have_css 'b', text: charge.cupom_code.to_s
    expect(page).to have_css 'b', text: 'R$ 900,00'
    expect(page).to have_css 'b', text: '4x de R$ 225,00'
    expect(page).to have_css 'h2', text: 'STATUS REPROVADA'
    expect(page).to have_css 'b', text: '15 - Banco emissor indisponível ou inexistente.'
    expect(page).not_to have_css '.check'
  end

  it 'does not exist button repproved charge' do
    adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
    adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
    product_groups = []
    product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups << product_group
    bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                               discount: 40, quantity: 2, product_group_id: product_group.key,
                               max_value: 100, admin: adm1, status: :approved,
                               approver: adm2)

    allow(SecureRandom).to receive(:alphanumeric).with(20).and_return 'CAMPUSCODELOCAWEBQSD'
    allow(SecureRandom).to receive(:hex).and_return '904778'
    allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')

    Coupon.create!(sale_id: bora_gastar.id)
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)
    create(:card_banner)
    create(:credit_card)
    charge = create(:charge, id_order: 350, credit_card_token: 'CAMPUSCODELOCAWEBQSD',
                             qty_instalments: 4, client_eni: '33322233345',
                             product_group_id: product_group.key, order_value: 1000.0, cupom_code: 'BORAGASTAR-ZZZZZZ')
    charge.reproved!

    login_as adm1
    visit charge_path(charge.id)

    expect(page).to have_css 'h2', text: 'STATUS REPROVADA'
    expect(page).not_to have_css 'button', text: 'Aprovar'
    expect(page).not_to have_css 'button', text: 'Reprovar'
    expect(page).not_to have_css 'h2', text: 'STATUS APROVADA'
    expect(page).not_to have_css 'h2', text: 'STATUS PENDENTE'
  end

  it 'without logging in' do
    adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
    adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
    product_groups = []
    product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups << product_group
    bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                               discount: 40, quantity: 2, product_group_id: product_group.key,
                               max_value: 100, admin: adm1, status: :approved,
                               approver: adm2)

    allow(SecureRandom).to receive(:alphanumeric).with(20).and_return 'CAMPUSCODELOCAWEBQSD'
    allow(SecureRandom).to receive(:hex).and_return '904778'
    allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')

    Coupon.create!(sale_id: bora_gastar.id)
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)
    create(:card_banner)
    create(:credit_card)
    charge = create(:charge, id_order: 350, credit_card_token: 'CAMPUSCODELOCAWEBQSD',
                             qty_instalments: 4, client_eni: '33322233345',
                             product_group_id: product_group.key, order_value: 1000.0, cupom_code: 'BORAGASTAR-ZZZZZZ')
    charge.reproved!

    visit charge_path(charge.id)

    expect(current_path).to eq new_admin_session_path
  end
end
