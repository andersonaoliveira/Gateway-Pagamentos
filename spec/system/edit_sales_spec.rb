require 'rails_helper'

describe 'Admin edit a pending sale' do
  it 'successifuly' do
    admin = create(:admin)
    product_groups = []
    product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups << product_group
    product_groups << ProductGroup.new(id: 2, name: 'Clound', key: 'CLOUD',
                                       description: 'Serviços de Armazenamento na Nuvem', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    Sale.create!(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                 product_group_id: 1, max_value: 200, admin: admin)
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)

    login_as(admin)
    visit sales_path
    click_on 'NatalIluminado'
    click_on 'Editar'
    fill_in 'Nome', with: 'Natal20off'
    click_on 'Salvar'

    expect(page).to have_content('Promoção atualizada com sucesso')
    expect(page).to have_content('Natal20off')
  end

  it 'but sale is approved' do
    admin = create(:admin)
    product_groups = []
    product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups << product_group
    product_groups << ProductGroup.new(id: 2, name: 'Clound', key: 'CLOUD',
                                       description: 'Serviços de Armazenamento na Nuvem', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    Sale.create!(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                 product_group_id: 1, max_value: 200, status: :approved, admin: admin)
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)

    login_as(admin)
    visit sales_path
    click_on 'NatalIluminado'

    expect(page).to have_content('NatalIluminado')
    expect(page).to have_content('APROVADA')
    expect(page).not_to have_link('Editar')
  end

  it 'but sale is disapproved' do
    admin = create(:admin)
    product_groups = []
    product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups << product_group
    product_groups << ProductGroup.new(id: 2, name: 'Clound', key: 'CLOUD',
                                       description: 'Serviços de Armazenamento na Nuvem', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    Sale.create!(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                 product_group_id: 1, max_value: 200, status: :disapproved, admin: admin)
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)

    login_as(admin)
    visit sales_path
    click_on 'NatalIluminado'

    expect(page).to have_content('NatalIluminado')
    expect(page).to have_content('REPROVADA')
    expect(page).not_to have_link('Editar')
  end

  it 'but name is mandatory' do
    admin = create(:admin)
    product_groups = []
    product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups << product_group
    product_groups << ProductGroup.new(id: 2, name: 'Clound', key: 'CLOUD',
                                       description: 'Serviços de Armazenamento na Nuvem', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    Sale.create!(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                 product_group_id: 1, max_value: 200, admin: admin)
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)

    login_as(admin)
    visit sales_path
    click_on 'NatalIluminado'
    click_on 'Editar'
    fill_in 'Nome', with: ''
    click_on 'Salvar'

    expect(page).to have_content('Erro! Não foi possível atualizar a promoção')
  end
end
