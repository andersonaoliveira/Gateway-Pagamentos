FactoryBot.define do
  factory :credit_card do
    holder_name { 'João Almeida' }
    number { '4444555566662222' }
    card_banner_id { 1 }
    valid_date { '2025-05' }
    cpf { '33322233345' }
    security_code { '789' }
  end
end
