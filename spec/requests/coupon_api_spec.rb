# rubocop:disable Layout/LineLength
require 'rails_helper'

describe 'Coupon API' do
  context 'GET /api/v1/coupons/validate_coupon' do
    it 'succesfully' do
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      product_groups = []
      product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      sale = create(:sale)
      sale.approved!
      sale.generate_coupons
      code = sale.coupons.last.code
      params = {
        code: code.to_s,
        product_group: 'Email',
        total: '1000.0'
      }

      get "/api/v1/coupons/validate_coupon/?code=#{params[:code]};product_group=#{params[:product_group]};total=#{params[:total]}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['coupon']).to eq 'válido'
      expect(parsed_response['desconto']).to eq '100.0'
    end

    it 'succesfully with discount equal maximum discount' do
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      product_groups = []
      product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      sale = create(:sale)
      sale.approved!
      sale.generate_coupons
      code = sale.coupons.last.code
      params = {
        code: code.to_s,
        product_group: 'Email',
        total: '5000.0'
      }

      get "/api/v1/coupons/validate_coupon/?code=#{params[:code]};product_group=#{params[:product_group]};total=#{params[:total]}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['coupon']).to eq 'válido'
      expect(parsed_response['desconto']).to eq '200.0'
    end

    it 'coupon not found' do
      sale = create(:sale)
      sale.approved!
      sale.generate_coupons
      product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      allow(ProductGroup).to receive(:find).with(1).and_return(product_group)

      params = {
        code: 'NATALILUMINADO-APZKDE',
        product_group: 'Email',
        total: '1000.0'
      }

      get "/api/v1/coupons/validate_coupon/?code=#{params[:code]};product_group=#{params[:product_group]};total=#{params[:total]}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['coupon']).to eq 'inválido'
      expect(parsed_response['error']).to eq 'Cupom não encontrado'
    end

    it 'sale expired' do
      sale = create(:sale)
      sale.approved!
      sale.generate_coupons
      sale.expiration_date = '12/12/2012'
      sale.save
      product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      allow(ProductGroup).to receive(:find).with(1).and_return(product_group)
      code = sale.coupons.last.code
      params = {
        code: code.to_s,
        product_group: 'Email',
        total: '1000.0'
      }

      get "/api/v1/coupons/validate_coupon/?code=#{params[:code]};product_group=#{params[:product_group]};total=#{params[:total]}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['coupon']).to eq 'inválido'
      expect(parsed_response['error']).to eq 'Promoção expirada'
    end

    it 'product_group invalid' do
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      product_groups = []
      product_group = ProductGroup.new(id: 1, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      sale = create(:sale)
      sale.approved!
      sale.generate_coupons
      code = sale.coupons.last.code
      params = {
        code: code.to_s,
        product_group: 'Cloud',
        total: '1000.0'
      }

      get "/api/v1/coupons/validate_coupon/?code=#{params[:code]};product_group=#{params[:product_group]};total=#{params[:total]}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['coupon']).to eq 'inválido'
      expect(parsed_response['error']).to eq 'O cupom não é válido para este grupo de produtos'
    end
  end
end
# rubocop:enable Layout/LineLength
