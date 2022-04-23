require 'rails_helper'

describe 'Administrator view all sales' do
  it 'successfully' do
    admin = create(:admin)
    ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    ProductGroup.new(id: 2, name: 'Clound', key: 'CLOUD',
                     description: 'Serviços de Armazenamento na Nuvem', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    Sale.create!(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                 product_group_id: 1, max_value: 200, admin: admin)
    Sale.create!(name: 'BlackFriday', expiration_date: '30/11/2022', discount: 20, quantity: 80,
                 product_group_id: 2, max_value: 300, admin: admin, status: :approved)
    Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022', discount: 40, quantity: 90,
                 product_group_id: 1, max_value: 100, admin: admin, status: :disapproved)

    login_as(admin)
    visit root_path
    click_on 'Visualizar Promoções'

    expect(page).to have_content('NatalIluminado')
    expect(page).to have_content('Pendente')
    expect(page).to have_content('ADMIN')
    expect(page).to have_content('BlackFriday')
    expect(page).to have_content('Aprovada')
    expect(page).to have_content('BoraGastar')
    expect(page).to have_content('Reprovada')
  end

  it 'but its empty' do
    admin = create(:admin)

    login_as(admin)
    visit root_path
    click_on 'Visualizar Promoções'

    expect(page).to have_content('Não existem promoções cadastradas no sistema')
  end
end
