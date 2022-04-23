require 'rails_helper'

describe 'Charge API' do
  context 'POST /api/v1/charges' do
    it 'successfull' do
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
      adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
      product_groups = []
      product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                                 discount: 40, quantity: 2, product_group_id: 'EMAIL',
                                 max_value: 100, admin: adm1, status: :approved,
                                 approver: adm2)
      Coupon.create!(sale_id: bora_gastar.id)
      create(:card_banner)
      create(:credit_card, cpf: '11122233345')

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": 123,
                "product_group_id": "EMAIL",
                "order_value": 1000.0,
                "cupom_code": "BORAGASTAR-ZZZZZZ",
                "client_eni": "11122233345",
                "credit_card_token": "CAMPUSCODELOCAWEBQSD",
                "qty_instalments": 10}', headers: headers

      expect(response.status).to eq 201
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to include 'product_group_id'
      expect(parsed_response).not_to include 'order_value'
      expect(parsed_response).not_to include 'cupom_code'
      expect(parsed_response).not_to include 'credit_card_token'
      expect(parsed_response).not_to include 'qty_instalments'
      expect(parsed_response['id']).to eq 1
      expect(parsed_response['id_order']).to eq 123
      expect(parsed_response['client_eni']).to eq '11122233345'
      expect(parsed_response['status']).to eq 'pending'
      expect(parsed_response['total_charge']).to eq '900.0'
    end

    it 'unsuccessful with blank fields' do
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": "",
                     "product_group_id": "",
                     "order_value": "",
                     "cupom_code": "",
                     "client_eni": "",
                     "credit_card_token": "",
                     "qty_instalments": ""}', headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Id do pedido não pode ficar em branco'
      expect(response.body).to include 'Id do grupo de produtos não pode ficar em branco'
      expect(response.body).to include 'Valor do pedido não pode ficar em branco'
      expect(response.body).to include 'CPF do cliente não pode ficar em branco'
      expect(response.body).to include 'Token do cartão de crédito não pode ficar em branco'
      expect(response.body).to include 'Quantidade de parcelas não pode ficar em branco'
    end

    it 'unsuccessfull with coupon not found' do
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
      adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
      product_groups = []
      product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                                 discount: 40, quantity: 2, product_group_id: 'EMAIL',
                                 max_value: 100, admin: adm1, status: :approved,
                                 approver: adm2)
      Coupon.create!(sale_id: bora_gastar.id)
      create(:card_banner)
      create(:credit_card, cpf: '11122233345')

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": 123,
                "product_group_id": "EMAIL",
                "order_value": 1000.0,
                "cupom_code": "BORAGASTAR-XXXXXX",
                "client_eni": "11122233345",
                "credit_card_token": "CAMPUSCODELOCAWEBQSD",
                "qty_instalments": 10}', headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Cupom de desconto não encontrado'
    end

    it 'unsuccessfull with sale expirated' do
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
      adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
      product_groups = []
      product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2021',
                                 discount: 40, quantity: 2, product_group_id: 'EMAIL',
                                 max_value: 100, admin: adm1, status: :approved,
                                 approver: adm2)
      Coupon.create!(sale_id: bora_gastar.id)
      create(:card_banner)
      create(:credit_card, cpf: '11122233345')

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": 123,
                "product_group_id": "EMAIL",
                "order_value": 1000.0,
                "cupom_code": "BORAGASTAR-ZZZZZZ",
                "client_eni": "11122233345",
                "credit_card_token": "CAMPUSCODELOCAWEBQSD",
                "qty_instalments": 10}', headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Cupom de desconto com promoção expirada'
    end

    it 'unsuccessfull with coupon invalid for sale' do
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
      adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
      product_groups = []
      product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                                 discount: 40, quantity: 2, product_group_id: 'EMAIL',
                                 max_value: 100, admin: adm1, status: :approved,
                                 approver: adm2)
      Coupon.create!(sale_id: bora_gastar.id)
      create(:card_banner)
      create(:credit_card, cpf: '11122233345')

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": 123,
                "product_group_id": "CLOUD",
                "order_value": 1000.0,
                "cupom_code": "BORAGASTAR-ZZZZZZ",
                "client_eni": "11122233345",
                "credit_card_token": "CAMPUSCODELOCAWEBQSD",
                "qty_instalments": 10}', headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Cupom de desconto não é válido para este grupo de produtos'
    end

    it 'unsuccessfull with coupon used' do
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
      adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
      product_groups = []
      product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                                 discount: 40, quantity: 2, product_group_id: 'EMAIL',
                                 max_value: 100, admin: adm1, status: :approved,
                                 approver: adm2)
      Coupon.create!(sale_id: bora_gastar.id, status: :used)
      create(:card_banner)
      create(:credit_card, cpf: '11122233345')

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": 123,
                "product_group_id": "EMAIL",
                "order_value": 1000.0,
                "cupom_code": "BORAGASTAR-ZZZZZZ",
                "client_eni": "11122233345",
                "credit_card_token": "CAMPUSCODELOCAWEBQSD",
                "qty_instalments": 10}', headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Cupom de desconto já utilizado'
    end

    it 'unsuccessfull with credit card token not found' do
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
      adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
      product_groups = []
      product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                                 discount: 40, quantity: 2, product_group_id: 'EMAIL',
                                 max_value: 100, admin: adm1, status: :approved,
                                 approver: adm2)
      Coupon.create!(sale_id: bora_gastar.id)
      create(:card_banner)
      create(:credit_card, cpf: '11122233345')

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": 123,
                "product_group_id": "EMAIL",
                "order_value": 1000.0,
                "cupom_code": "BORAGASTAR-ZZZZZZ",
                "client_eni": "11122233345",
                "credit_card_token": "LOCAWEBQSDCAMPUSCODE",
                "qty_instalments": 10}', headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Token do cartão de crédito não encontrado'
    end

    it 'unsuccessfull with credit card token invalid' do
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
      adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
      product_groups = []
      product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                                 discount: 40, quantity: 2, product_group_id: 'EMAIL',
                                 max_value: 100, admin: adm1, status: :approved,
                                 approver: adm2)
      Coupon.create!(sale_id: bora_gastar.id)
      create(:card_banner)
      create(:credit_card, cpf: '11122233345')

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": 123,
                "product_group_id": "EMAIL",
                "order_value": 1000.0,
                "cupom_code": "BORAGASTAR-ZZZZZZ",
                "client_eni": "11199933345",
                "credit_card_token": "CAMPUSCODELOCAWEBQSD",
                "qty_instalments": 10}', headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Token do cartão de crédito não associado a esse cliente'
    end

    it 'unsuccessfull with quantity instalments invalid' do
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
      adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
      product_groups = []
      product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                                 discount: 40, quantity: 2, product_group_id: 'EMAIL',
                                 max_value: 100, admin: adm1, status: :approved,
                                 approver: adm2)
      Coupon.create!(sale_id: bora_gastar.id)
      create(:card_banner, max_instalments: 4)
      create(:credit_card, cpf: '11122233345')

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": 123,
                "product_group_id": "EMAIL",
                "order_value": 1000.0,
                "cupom_code": "BORAGASTAR-ZZZZZZ",
                "client_eni": "11122233345",
                "credit_card_token": "CAMPUSCODELOCAWEBQSD",
                "qty_instalments": 10}', headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Quantidade de parcelas inválida, máximo de 4 para essa bandeira'
    end

    it 'unsuccessful with id_order status approved' do
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
      adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
      product_groups = []
      product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                                 discount: 40, quantity: 2, product_group_id: 'EMAIL',
                                 max_value: 100, admin: adm1, status: :approved,
                                 approver: adm2)
      Coupon.create!(sale_id: bora_gastar.id)
      create(:card_banner)
      create(:credit_card, cpf: '11122233345')
      create(:charge, id_order: 123, product_group_id: 'EMAIL', order_value: 1000.0,
                      cupom_code: 'BORAGASTAR-ZZZZZZ', client_eni: '11122233345',
                      credit_card_token: 'CAMPUSCODELOCAWEBQSD', qty_instalments: 10,
                      status: :approved)

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": 123,
                "product_group_id": "EMAIL",
                "order_value": 1000.0,
                "cupom_code": "BORAGASTAR-ZZZZZZ",
                "client_eni": "11122233345",
                "credit_card_token": "CAMPUSCODELOCAWEBQSD",
                "qty_instalments": 10}', headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Id do pedido já existe cobrança aprovada'
    end

    it 'unsuccessful with id_order status pending' do
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
      adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
      product_groups = []
      product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                                 discount: 40, quantity: 2, product_group_id: 'EMAIL',
                                 max_value: 100, admin: adm1, status: :approved,
                                 approver: adm2)
      Coupon.create!(sale_id: bora_gastar.id)
      create(:card_banner)
      create(:credit_card, cpf: '11122233345')
      create(:charge, id_order: 123, product_group_id: 'EMAIL', order_value: 1000.0,
                      cupom_code: 'BORAGASTAR-ZZZZZZ', client_eni: '11122233345',
                      credit_card_token: 'CAMPUSCODELOCAWEBQSD', qty_instalments: 10)

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": 123,
                "product_group_id": "EMAIL",
                "order_value": 1000.0,
                "cupom_code": "BORAGASTAR-ZZZZZZ",
                "client_eni": "11122233345",
                "credit_card_token": "CAMPUSCODELOCAWEBQSD",
                "qty_instalments": 10}', headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Id do pedido já existe cobrança pendente'
    end

    it 'unsuccessful with id_order status reproved' do
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ZZZZZZ')
      adm1 = Admin.create!({ email: 'admin1@locaweb.com.br', password: '123456' })
      adm2 = Admin.create!({ email: 'admin2@locaweb.com.br', password: '654321' })
      product_groups = []
      product_group = ProductGroup.new(id: 7, name: 'Email', key: 'EMAIL',
                                       description: 'Serviços de Email',
                                       icon: 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png')
      product_groups << product_group
      allow(ProductGroup).to receive(:all).and_return(product_groups)
      allow(ProductGroup).to receive(:find).and_return(product_group)
      bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                                 discount: 40, quantity: 2, product_group_id: 'EMAIL',
                                 max_value: 100, admin: adm1, status: :approved,
                                 approver: adm2)
      Coupon.create!(sale_id: bora_gastar.id)
      create(:card_banner)
      create(:credit_card, cpf: '11122233345')
      create(:charge, id_order: 123, product_group_id: 'EMAIL', order_value: 1000.0,
                      cupom_code: 'BORAGASTAR-ZZZZZZ', client_eni: '11122233345',
                      credit_card_token: 'CAMPUSCODELOCAWEBQSD', qty_instalments: 10,
                      status: :reproved)

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/charges',
           params: '{"id_order": 123,
                "product_group_id": "EMAIL",
                "order_value": 1000.0,
                "cupom_code": "BORAGASTAR-ZZZZZZ",
                "client_eni": "11122233345",
                "credit_card_token": "CAMPUSCODELOCAWEBQSD",
                "qty_instalments": 10}', headers: headers

      expect(response.status).to eq 201
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq 2
      expect(parsed_response['status']).to eq 'pending'
    end
  end
end
