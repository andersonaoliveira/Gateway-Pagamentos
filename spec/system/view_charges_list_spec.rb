require 'rails_helper'

describe 'Admin view charges list' do
  it 'and the register is empty' do
    admin = create(:admin)

    login_as admin
    visit root_path
    click_on 'Visualizar Cobranças'

    expect(page).to have_css 'h3', text: 'Não existem cobranças no sistema'
  end

  it 'successfully' do
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
    c3 = create(:charge, id_order: 486, credit_card_token: 'CAMPUSCODELOCAWEBQSD', cupom_code: 'BORAGASTAR-ZZZZZZ')
    c2.reproved!
    c3.approved!

    login_as adm1
    visit root_path
    click_on 'Visualizar Cobranças'

    expect(page).to have_css 'h1', text: 'COBRANÇAS'
    expect(page).to have_css 'th', text: 'Ordem de Cobrança'
    expect(page).to have_css 'th', text: 'Número do Pedido'
    expect(page).to have_css 'th', text: 'Status'
    expect(page).to have_css "tr#charge-#{c1.id} td", text: '1'
    expect(page).to have_css "tr#charge-#{c1.id} td", text: '522'
    expect(page).to have_css "tr#charge-#{c1.id} td", text: 'Pendente'
    expect(page).to have_css "tr#charge-#{c2.id} td", text: '2'
    expect(page).to have_css "tr#charge-#{c2.id} td", text: '789'
    expect(page).to have_css "tr#charge-#{c2.id} td", text: 'Reprovada'
    expect(page).to have_css "tr#charge-#{c3.id} td", text: '3'
    expect(page).to have_css "tr#charge-#{c3.id} td", text: '486'
    expect(page).to have_css "tr#charge-#{c3.id} td", text: 'Aprovada'
  end

  it 'successfully filtering the approved' do
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
    c3 = create(:charge, id_order: 486, credit_card_token: 'CAMPUSCODELOCAWEBQSD', cupom_code: 'BORAGASTAR-ZZZZZZ')
    c2.reproved!
    c3.approved!

    login_as adm1
    visit charges_path
    click_on 'Aprovadas'

    expect(page).to have_css 'h1', text: 'COBRANÇAS APROVADAS'
    expect(page).to have_css "tr#charge-#{c3.id} td", text: '3'
    expect(page).to have_css "tr#charge-#{c3.id} td", text: '486'
    expect(page).to have_css "tr#charge-#{c3.id} td", text: 'Aprovada'
    expect(page).not_to have_css "tr#charge-#{c1.id} td", text: '1'
    expect(page).not_to have_css "tr#charge-#{c1.id} td", text: '522'
    expect(page).not_to have_css "tr#charge-#{c1.id} td", text: 'Pendente'
    expect(page).not_to have_css "tr#charge-#{c2.id} td", text: '2'
    expect(page).not_to have_css "tr#charge-#{c2.id} td", text: '789'
    expect(page).not_to have_css "tr#charge-#{c2.id} td", text: 'Reprovada'
  end

  it 'and there are no approved charges' do
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
    create(:charge, id_order: 522, credit_card_token: 'CAMPUSCODELOCAWEBQSD', cupom_code: 'BORAGASTAR-ZZZZZZ')

    login_as adm1
    visit charges_path
    click_on 'Aprovadas'

    expect(page).to have_css 'h3', text: 'Não existem cobranças aprovadas no sistema'
  end

  it 'successfully filtering the repproved' do
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
    c3 = create(:charge, id_order: 486, credit_card_token: 'CAMPUSCODELOCAWEBQSD', cupom_code: 'BORAGASTAR-ZZZZZZ')
    c2.reproved!
    c3.approved!

    login_as adm1
    visit charges_path
    click_on 'Reprovadas'

    expect(page).to have_css 'h1', text: 'COBRANÇAS REPROVADAS'
    expect(page).to have_css "tr#charge-#{c2.id} td", text: '2'
    expect(page).to have_css "tr#charge-#{c2.id} td", text: '789'
    expect(page).to have_css "tr#charge-#{c2.id} td", text: 'Reprovada'
    expect(page).not_to have_css "tr#charge-#{c1.id} td", text: '1'
    expect(page).not_to have_css "tr#charge-#{c1.id} td", text: '522'
    expect(page).not_to have_css "tr#charge-#{c1.id} td", text: 'Pendente'
    expect(page).not_to have_css "tr#charge-#{c3.id} td", text: '3'
    expect(page).not_to have_css "tr#charge-#{c3.id} td", text: '486'
    expect(page).not_to have_css "tr#charge-#{c3.id} td", text: 'Aprovada'
  end

  it 'and there are no reproved charges' do
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
    create(:charge, id_order: 522, credit_card_token: 'CAMPUSCODELOCAWEBQSD', cupom_code: 'BORAGASTAR-ZZZZZZ')

    login_as adm1
    visit charges_path
    click_on 'Reprovadas'

    expect(page).to have_css 'h3', text: 'Não existem cobranças reprovadas no sistema'
  end

  it 'successfully filtering the pending' do
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
    c3 = create(:charge, id_order: 486, credit_card_token: 'CAMPUSCODELOCAWEBQSD', cupom_code: 'BORAGASTAR-ZZZZZZ')
    c2.reproved!
    c3.approved!

    login_as adm1
    visit root_path
    click_on 'Visualizar Cobranças'
    click_on 'Pendentes'

    expect(page).to have_css 'h1', text: 'COBRANÇAS PENDENTES'
    expect(page).to have_css "tr#charge-#{c1.id} td", text: '1'
    expect(page).to have_css "tr#charge-#{c1.id} td", text: '522'
    expect(page).to have_css "tr#charge-#{c1.id} td", text: 'Pendente'
    expect(page).not_to have_css "tr#charge-#{c2.id} td", text: '2'
    expect(page).not_to have_css "tr#charge-#{c2.id} td", text: '789'
    expect(page).not_to have_css "tr#charge-#{c2.id} td", text: 'Reprovada'
    expect(page).not_to have_css "tr#charge-#{c3.id} td", text: '3'
    expect(page).not_to have_css "tr#charge-#{c3.id} td", text: '486'
    expect(page).not_to have_css "tr#charge-#{c3.id} td", text: 'Aprovada'
  end

  it 'and there are no reproved charges' do
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
    c1.approved!

    login_as adm1
    visit charges_path
    click_on 'Pendentes'

    expect(page).to have_css 'h3', text: 'Não existem cobranças pendentes no sistema'
  end
end
