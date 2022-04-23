require 'rails_helper'

describe 'Admin visit home page' do
  it 'and generate coupons successfully' do
    adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
    adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
    pg1 = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                           description: 'Serviços de Email',
                           icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    product_groups = []
    product_groups << pg1
    allow(ProductGroup).to receive(:all).and_return(product_groups)
    allow(ProductGroup).to receive(:find).and_return(pg1)
    bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                               discount: 40, quantity: 10, product_group_id: pg1.id,
                               max_value: 100, admin: adm1, status: :approved,
                               approver: adm2)

    login_as adm1
    visit sales_path
    click_on 'BoraGastar'
    click_on 'Gerar Cupons'

    expect(current_path).to eq sale_path(bora_gastar.id)
    expect(page).to have_css 'h1', text: "CUPONS DA PROMOÇÃO #{bora_gastar.name.upcase}"
    expect(page).to have_css 'td', text: /\ABORAGASTAR-[A-Z0-9]{6}\z/, count: 10
    expect(page).to have_css 'td', text: 'Disponível', count: 10
  end
end
