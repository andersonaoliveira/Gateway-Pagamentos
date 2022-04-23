require 'rails_helper'

describe 'Administrator approves a sale' do
  it 'and the same user try to approve sale' do
    user = Admin.create!({ email: 'pagamento@locaweb.com.br', password: '123456' })
    product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    allow(ProductGroup).to receive(:find).and_return(product_group)
    sale = Sale.create!(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                        product_group_id: 1, max_value: 1000, admin: user)
    login_as(user)

    visit sale_path(sale.id)

    expect(page).not_to have_button('Aprovar')
  end

  it 'and aproved with success' do
    sale_owner = Admin.create!({ email: 'pagamento@locaweb.com.br', password: '123456' })
    sale_approver = Admin.create!({ email: 'admin@locaweb.com.br', password: '123456' })
    product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                     description: 'Serviços de Email', icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
    allow(ProductGroup).to receive(:find).and_return(product_group)
    sale = Sale.create!(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                        product_group_id: 1, max_value: 1000, admin: sale_owner)

    login_as(sale_approver)
    visit sale_path(sale.id)
    click_on 'Aprovar'

    sale.reload
    expect(page).to have_content('STATUS APROVADA')
    expect(page).to have_content('PAGAMENTO')
    expect(sale.approver).to eq(sale_approver)
  end
end
