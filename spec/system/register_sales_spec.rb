require 'rails_helper'

describe 'Administrator register a sale' do
  it 'and visitor does not access the views' do
    visit new_sale_path

    expect(current_path).to eq(new_admin_session_path)
    expect(page).not_to have_content('Cadastrar promoção')
  end

  it 'and view a form successfully' do
    admin = create(:admin)
    product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_group_two = ProductGroup.new(id: 2, name: 'Clound', key: 'CLOUD',
                                         description: 'Serviços de Armazenamento na Nuvem', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups = []
    product_groups << product_group
    product_groups << product_group_two
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)

    login_as(admin)
    visit root_path
    click_on 'Cadastrar Promoção'

    expect(current_path).to eq new_sale_path
    expect(page).to have_content('CADASTRAR PROMOÇÃO')
    expect(page).to have_field('Nome')
    expect(page).to have_field('Prazo de validade')
    expect(page).to have_field('Valor máximo permitido')
    expect(page).to have_field('Desconto')
    expect(page).to have_field('Quantidade')
  end

  it 'and fill the form with successfully' do
    admin = create(:admin)
    product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_group_two = ProductGroup.new(id: 2, name: 'Clound', key: 'CLOUD',
                                         description: 'Serviços de Armazenamento na Nuvem', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups = []
    product_groups << product_group
    product_groups << product_group_two
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)

    login_as(admin)
    visit root_path
    click_on 'Cadastrar Promoção'
    fill_in 'Nome', with: 'NatalIluminado'
    fill_in 'Prazo de validade', with: DateTime.current.strftime('25/12/2022')
    fill_in 'Valor máximo permitido', with: 100
    fill_in 'Desconto', with: 10
    fill_in 'Quantidade', with: 500
    select 'Email', from: 'Produtos'
    click_on 'Salvar'

    expect(page).to have_content('Promoção cadastrada com sucesso')
    expect(page).to have_content('NatalIluminado')
    expect(page).to have_content('VALIDADE')
    expect(page).to have_content('25/12/2022')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('500')
    expect(page).to have_content('Email')
    expect(page).not_to have_content('Cloud')
  end

  it 'and name is required' do
    admin = create(:admin)
    product_groups = []
    product_groups << ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')

    allow(ProductGroup).to receive(:all).and_return(product_groups)
    login_as(admin)
    visit root_path
    click_on 'Cadastrar Promoção'
    fill_in 'Prazo de validade', with: DateTime.current.strftime('25/12/2022')
    fill_in 'Valor máximo permitido', with: 100
    fill_in 'Desconto', with: 10
    fill_in 'Quantidade', with: 500
    select 'Email', from: 'Produtos'
    click_on 'Salvar'

    expect(page).to have_content('Promoção não pode ser cadastrada')
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  it 'and name has to be unique' do
    admin = create(:admin)
    product_groups = []
    product_groups << ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    Sale.create!(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                 product_group_id: 1, max_value: 1000, admin: admin)

    allow(ProductGroup).to receive(:all).and_return(product_groups)
    login_as(admin)
    visit root_path
    click_on 'Cadastrar Promoção'
    fill_in 'Nome', with: 'NatalIluminado'
    fill_in 'Prazo de validade', with: DateTime.current.strftime('31/12/2022')
    fill_in 'Valor máximo permitido', with: 100
    fill_in 'Desconto', with: 10
    fill_in 'Quantidade', with: 500
    select 'Email', from: 'Produtos'
    click_on 'Salvar'

    expect(page).to have_content('Promoção não pode ser cadastrada')
    expect(page).to have_content('Nome já está em uso')
  end

  it 'and product_groups are nil' do
    admin = create(:admin)
    allow(ProductGroup).to receive(:all).and_return(nil)

    login_as(admin)
    visit root_path
    click_on 'Cadastrar Promoção'

    expect(page).to have_content('Não foi possível carregar a página')
    expect(page).not_to have_content('Cadastrar promoção')
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Prazo de validade')
    expect(page).not_to have_field('Valor máximo permitido')
    expect(page).not_to have_field('Desconto')
    expect(page).not_to have_field('Quantidade')
  end
end
