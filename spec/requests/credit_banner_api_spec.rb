require 'rails_helper'

describe 'Card banner API' do
  context 'GET /api/v1/card_banners' do
    it 'com sucesso' do
      create(:card_banner)
      create(:card_banner, name: 'MasterCard')
      get '/api/v1/card_banners'
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response[0]['name']).to eq 'Visa'
      expect(parsed_response[1]['name']).to eq 'MasterCard'
      expect(parsed_response[0]['percentual_tax']).to eq 10.0
    end

    it 'resposta vazia' do
      get '/api/v1/card_banners'
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq []
    end
  end
  context 'GET /api/v1/card_banners/id' do
    it 'com sucesso' do
      card_banner = create(:card_banner, max_instalments: 12)
      get "/api/v1/card_banners/#{card_banner.id}"
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['max_instalments']).to eq 12
    end
  end
end
