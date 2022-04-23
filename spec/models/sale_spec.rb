require 'rails_helper'

RSpec.describe Sale, type: :model do
  context 'all fields are mandatory' do
    it 'name is mandatory' do
      sale = Sale.new(expiration_date: '25/12/2022', discount: 10, quantity: 100, product_group_id: 1, max_value: 1000)
      result = sale.valid?

      expect(result).to eq false
    end

    it 'expiration date is mandatory' do
      sale = Sale.new(name: 'NatalIluminado', discount: 10, quantity: 100, product_group_id: 1, max_value: 1000)
      result = sale.valid?

      expect(result).to eq false
    end

    it 'discount is mandatory' do
      sale = Sale.new(name: 'NatalIluminado', expiration_date: '25/12/2022', quantity: 100, product_group_id: 1,
                      max_value: 1000)
      result = sale.valid?

      expect(result).to eq false
    end

    it 'quantity is mandatory' do
      sale = Sale.new(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, product_group_id: 1,
                      max_value: 1000)
      result = sale.valid?

      expect(result).to eq false
    end

    it 'product_id is mandatory' do
      sale = Sale.new(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                      max_value: 1000)
      result = sale.valid?

      expect(result).to eq false
    end

    it 'max_value date is mandatory' do
      sale = Sale.new(name: 'NatalIluminado', expiration_date: '25/12/2022', discount: 10, quantity: 100,
                      product_group_id: 1)
      result = sale.valid?

      expect(result).to eq false
    end
  end

  context 'generate coupons' do
    it 'sale cannot be disapproved' do
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

      bora_gastar.generate_coupons

      expect(bora_gastar.coupons.count).to be 0
    end

    it 'sale cannot be pending' do
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
                                 max_value: 100, admin: adm1, status: :pending)

      bora_gastar.generate_coupons

      expect(bora_gastar.coupons.count).to be 0
    end

    it 'sales coupon count cannot exceed limit' do
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
      bora_gastar.generate_coupons

      expect(bora_gastar.coupons.count).to be 90
    end
  end
end
