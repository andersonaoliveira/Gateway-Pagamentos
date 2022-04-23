require 'rails_helper'

describe 'Admin view a sale details' do
  it 'successfully' do
    admin = create(:admin)
    product_groups = []
    product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups << product_group
    product_groups << ProductGroup.new(id: 2, name: 'Clound', key: 'CLOUD',
                                       description: 'Serviços de Armazenamento na Nuvem', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    Sale.create!(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                 product_group_id: 1, max_value: 200, admin: admin)
    Sale.create!(name: 'BlackFriday', expiration_date: '30/11/2022', discount: 20, quantity: 80,
                 product_group_id: 2, max_value: 300, admin: admin, status: :approved)
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)

    login_as(admin)
    visit root_path
    click_on 'Visualizar Promoções'
    click_on 'NatalIluminado'

    expect(page).to have_css 'h1', text: 'DETALHES DA PROMOÇÃO NATALILUMINADO'
    expect(page).to have_css 'h6', text: 'CRIADA POR'
    expect(page).to have_css 'strong', text: 'ADMIN'
    expect(page).to have_content('NatalIluminado')
    expect(page).to have_content('25/12/2022')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('100')
    expect(page).to have_content('Email')
  end

  it 'successfully but Gestão de Produtos is down' do
    admin = create(:admin)
    product_groups = []
    product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups << product_group
    product_groups << ProductGroup.new(id: 2, name: 'Clound', key: 'CLOUD',
                                       description: 'Serviços de Armazenamento na Nuvem', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    Sale.create!(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                 product_group_id: 1, max_value: 200, admin: admin)
    Sale.create!(name: 'BlackFriday', expiration_date: '30/11/2022', discount: 20, quantity: 80,
                 product_group_id: 2, max_value: 300, admin: admin, status: :approved)
    allow(ProductGroup).to receive(:all).and_return(nil)
    allow(ProductGroup).to receive(:find).and_return(nil)

    login_as(admin)
    visit root_path
    click_on 'Visualizar Promoções'
    click_on 'NatalIluminado'

    expect(page).to have_css 'h1', text: 'DETALHES DA PROMOÇÃO NATALILUMINADO'
    expect(page).to have_css 'h6', text: 'CRIADA POR'
    expect(page).to have_css 'strong', text: 'ADMIN'
    expect(page).to have_content('NatalIluminado')
    expect(page).to have_content('25/12/2022')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('100')
    expect(page).not_to have_content('Email')
  end

  it 'and does not see the link to generate coupons for an unapproved sale' do
    adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
    pg1 = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                           description: 'Serviços de Email',
                           icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups = []
    product_groups << pg1
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(pg1)
    bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                               discount: 40, quantity: 90, product_group_id: pg1.id,
                               max_value: 100, admin: adm1, status: :disapproved)

    login_as adm1
    visit sale_path(bora_gastar.id)

    expect(page).not_to have_css 'a', text: 'Gerar Cupons'
  end
end
