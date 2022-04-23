require 'rails_helper'

describe 'User searches for charges' do
  it 'without success' do
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
                               discount: 40, quantity: 1, product_group_id: 7,
                               max_value: 100, admin: adm1, status: :approved,
                               approver: adm2)
    bora_gastar.generate_coupons
    create(:card_banner)
    create(:credit_card)
    c1 = create(:charge, id_order: 522, credit_card_token: 'CAMPUSCODELOCAWEBQSD', cupom_code: 'BORAGASTAR-ZZZZZZ')
    c2 = create(:charge, id_order: 789, credit_card_token: 'CAMPUSCODELOCAWEBQSD', cupom_code: 'BORAGASTAR-ZZZZZZ')
    c2.reproved!

    login_as adm1
    visit root_path
    click_on 'Visualizar Cobranças'
    fill_in 'Buscar Cobranças:', with: '11111111111'
    click_on 'Pesquisar'

    expect(page).not_to have_css 'strong', text: c1.id_order.to_s
    expect(page).not_to have_css 'strong', text: c2.id_order.to_s
    expect(page).to have_content('Não foram encontradas cobranças na pesquisa!')
  end

  it 'success' do
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
                               discount: 40, quantity: 1, product_group_id: 7,
                               max_value: 100, admin: adm1, status: :approved,
                               approver: adm2)
    bora_gastar.generate_coupons
    create(:card_banner)
    create(:credit_card)
    c1 = create(:charge, id_order: 522, credit_card_token: 'CAMPUSCODELOCAWEBQSD', cupom_code: 'BORAGASTAR-ZZZZZZ',
                         client_eni: '33322233345')
    c2 = create(:charge, id_order: 789, credit_card_token: 'CAMPUSCODELOCAWEBQSD', cupom_code: 'BORAGASTAR-ZZZZZZ',
                         client_eni: '33322233345')
    c2.reproved!

    login_as adm1
    visit root_path
    click_on 'Visualizar Cobranças'
    fill_in 'Buscar Cobranças:', with: '33322233345'
    click_on 'Pesquisar'

    expect(page).to have_content c1.id_order.to_s
    expect(page).to have_content c2.id_order.to_s
  end
end
