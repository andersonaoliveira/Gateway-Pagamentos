require 'rails_helper'

RSpec.describe Admin, type: :model do
  context '.email_domain' do
    it 'dominio @locaweb.com.br' do
      admin = Admin.new(email: 'admin@locaweb.com.br', password: 'admin1')
      result = admin.valid?
      expect(result).to eq true
    end

    it 'falha em dominio diverso' do
      admin = Admin.new(email: 'admin@email.com', password: 'admin1')
      result = admin.valid?
      expect(result).to eq false
    end

    it 'formato inválido' do
      admin = Admin.new(email: 'adminemail', password: 'admin1')
      result = admin.valid?
      expect(result).to eq false
    end

    it 'campo ausente' do
      admin = Admin.new(email: '', password: 'admin1')
      result = admin.valid?
      expect(result).to eq false
    end
  end
end
