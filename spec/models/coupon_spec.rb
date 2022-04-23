require 'rails_helper'

RSpec.describe Coupon, type: :model do
  it 'code has to be unique' do
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
                               discount: 40, quantity: 90, product_group_id: pg1.id,
                               max_value: 100, admin: adm1, status: :approved,
                               approver: adm2)
    cupom1 = Coupon.create!(sale_id: bora_gastar.id)
    cupom2 = Coupon.create!(sale_id: bora_gastar.id)
    cupom2.code = cupom1.code
    cupom2.save

    expect(cupom2.code).to_not eq cupom1.code
  end

  it 'format code is invalid' do
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
                               discount: 40, quantity: 90, product_group_id: pg1.id,
                               max_value: 100, admin: adm1, status: :approved,
                               approver: adm2)
    cupom = Coupon.new(sale_id: bora_gastar.id, code: 'capus-2022')
    cupom.save

    expect(cupom.code).not_to eq 'campus-2022'
  end

  it 'number of coupons cannot exceed the limit' do
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
                               discount: 40, quantity: 90, product_group_id: pg1.id,
                               max_value: 100, admin: adm1, status: :approved,
                               approver: adm2)
    bora_gastar.generate_coupons
    cupom = Coupon.new(sale: bora_gastar)
    cupom.save

    expect(bora_gastar.coupons.count).to eq 90
    expect(cupom.errors).to include('Não foi possível gerar o cupom')
  end

  it 'promotion must be approved ' do
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
    cupom = Coupon.new(sale: bora_gastar)
    cupom.save

    expect(bora_gastar.coupons.count).to eq 0
    expect(cupom.errors).to include('Não foi possível gerar o cupom')
  end
end
