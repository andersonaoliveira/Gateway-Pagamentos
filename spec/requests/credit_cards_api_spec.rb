require 'rails_helper'

# rubocop:disable Lint/UselessAssignment
describe 'Creditcard API' do
  context 'POST /api/v1/credit_cards' do
    it 'successfull' do
      c1 = CardBanner.create!(name: 'Visa', max_instalments: 12, discount: 8,
                              percentual_tax: 10, max_tax: 10)
      allow(SecureRandom).to receive(:alphanumeric).with(20)
                                                   .and_return 'CAMPUSCODELOCAWEBQSD'
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/credit_cards', params: '{"holder_name": "Pedro de Lara",
                                             "cpf": "11111111111",
                                             "card_banner_id": 1,
																						 "number": "4444555566667777",
																						 "valid_date": "2024-01",
                                             "security_code": "222"}',
                                   headers: headers

      expect(response.status).to eq 201
      expect(response.content_type).to include('application/json')
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['cpf']).to eq '11111111111'
      expect(parsed_response['token']).to eq 'CAMPUSCODELOCAWEBQSD'
    end

    it 'unsuccessfull with invalid card banner' do
      c1 = CardBanner.create!(name: 'Visa', max_instalments: 12, discount: 8,
                              percentual_tax: 10, max_tax: 10)
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/credit_cards', params: '{"holder_name": "Pedro de Lara",
                                             "cpf": "11111111111",
                                             "card_banner_id": 2,
																						 "number": "4444555566667777",
																						 "valid_date": "2024-01",
                                             "security_code": "222"}',
                                   headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Bandeira do cartão é obrigatório(a)'
    end

    it 'unsuccessful with blank fields' do
      c1 = CardBanner.create!(name: 'Visa', max_instalments: 12, discount: 8,
                              percentual_tax: 10, max_tax: 10)

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/credit_cards', params: '{"holder_name": "",
                                             "cpf": "",
																						 "card_banner_id": "",
																						 "number": "",
																						 "valid_date": "",
                                             "security_code": ""}',
                                   headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Nome do titular não pode ficar em branco'
      expect(response.body).to include 'CPF não pode ficar em branco'
      expect(response.body).to include 'Bandeira do cartão é obrigatório(a)'
      expect(response.body).to include 'Número não pode ficar em branco'
      expect(response.body).to include 'Data de validade não pode ficar em branco'
      expect(response.body).to include 'Código de segurança não pode ficar em branco'
    end

    it 'unsuccessful without unique number' do
      c1 = CardBanner.create!(name: 'Visa', max_instalments: 12, discount: 8,
                              percentual_tax: 10, max_tax: 10)
      cc = CreditCard.create!(holder_name: 'Pedro de Lara', cpf: '11111111111',
                              card_banner_id: 1, number: '4444555566667777',
                              valid_date: '2024-01', security_code: '222')

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/credit_cards', params: '{"holder_name": "Pedro de Lara",
                                             "cpf": "11111111111",
																						 "card_banner_id": 1,
																						 "number": "4444555566667777",
																						 "valid_date": "2026-01",
                                             "security_code": "333"}',
                                   headers: headers

      expect(response.status).to eq 422
      expect(response.body).to include 'Número já está em uso'
    end
  end
end
# rubocop:enable Lint/UselessAssignment
