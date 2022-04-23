require 'rails_helper'

describe 'User searches for cupom' do
  it 'successfully' do
    admin = create(:admin)
    product_group = ProductGroup.new(id: 1, name: 'Email2', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')

    product_groups = []
    product_groups << product_group
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)
    sale = Sale.create!(name: 'ABORAGASTAR', expiration_date: '25/12/2022', discount: 50, quantity: 8,
                        product_group_id: 1, max_value: 1000, admin: admin)
    sale.approved!

    login_as(admin)
    visit sale_path(sale.id)
    click_on 'Gerar Cupons'
    fill_in :query, with: 'ABORAGAST'
    click_on 'Buscar'

    expect(current_path).to eq search_coupons_path
    expect(page).to have_css 'h1', text: 'CUPONS ENCONTRADOS'
    expect(page).to have_css 'td.code', text: 'ABORAGASTAR-', count: 8
    expect(page).to have_css 'td', text: 'Disponível', count: 8
    expect(page).not_to have_content 'Nenhum cupom encontrado'
  end

  it 'unsuccessfully' do
    admin = create(:admin)
    product_group = ProductGroup.new(id: 1, name: 'Email2', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')

    product_groups = []
    product_groups << product_group
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(product_group)
    sale = Sale.create!(name: '50OFF', expiration_date: '25/12/2022', discount: 50, quantity: 8,
                        product_group_id: 1, max_value: 1000, admin: admin)
    sale.approved!

    login_as(admin)
    visit sale_path(sale.id)
    click_on 'Gerar Cupons'
    fill_in :query, with: 'ABSDAREDS'
    click_on 'Buscar'

    expect(current_path).to eq search_coupons_path
    expect(page).to have_css 'h1', text: 'CUPONS ENCONTRADOS'
    expect(page).to have_content 'Nenhum cupom encontrado'
    expect(page).not_to have_content '50OFF'
  end
end
