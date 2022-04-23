require 'rails_helper'

describe 'User searches for sales' do
  it 'without success' do
    admin = create(:admin)
    product_group = ProductGroup.new(id: 1, name: 'Email2', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_group_two = ProductGroup.new(id: 2, name: 'Clound', key: 'CLOUD',
                                         description: 'Serviços de Armazenamento na Nuvem', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups = []
    product_groups << product_group
    product_groups << product_group_two
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)
    Sale.create!(name: '50OFF', expiration_date: '25/12/2022', discount: 50, quantity: 100,
                 product_group_id: 1, max_value: 1000, admin: admin)
    Sale.create!(name: '20OFF', expiration_date: '22/10/2022', discount: 20, quantity: 100,
                 product_group_id: 2, max_value: 400, admin: admin)

    login_as(admin)
    visit sales_path
    fill_in 'Buscar promoção:', with: 'something'
    click_on 'Pesquisar'

    expect(page).not_to have_content('20OFF')
    expect(page).not_to have_content('50OFF')
    expect(page).to have_content('Nenhuma promoção encontrada.')
  end

  it 'success' do
    admin = create(:admin)
    product_group = ProductGroup.new(id: 1, name: 'Email2', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_group_two = ProductGroup.new(id: 2, name: 'Clound', key: 'CLOUD',
                                         description: 'Serviços de Armazenamento na Nuvem', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups = []
    product_groups << product_group
    product_groups << product_group_two
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)
    Sale.create!(name: '50OFF', expiration_date: '25/12/2022', discount: 50, quantity: 100,
                 product_group_id: 1, max_value: 1000, admin: admin)
    Sale.create!(name: '20OFF', expiration_date: '22/10/2022', discount: 20, quantity: 100,
                 product_group_id: 2, max_value: 400, admin: admin)
    Sale.create!(name: 'NATALLUZ', expiration_date: '26/10/2022', discount: 70, quantity: 100,
                 product_group_id: 2, max_value: 400, admin: admin)

    login_as(admin)
    visit sales_path
    fill_in 'Buscar promoção:', with: 'OFF'
    click_on 'Pesquisar'

    expect(page).not_to have_content('NATALLUZ')
    expect(page).to have_content('20OFF')
    expect(page).to have_content('50OFF')
    expect(page).to have_content(20)
    expect(page).to have_content(50)
  end
end
