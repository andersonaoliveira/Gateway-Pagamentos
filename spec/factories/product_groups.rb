FactoryBot.define do
  factory :product_group do
    id { 1 }
    name { 'Email' }
    key { 'EMAIL' }
    description { 'Serviços de Email' }
    icon { 'https://cdn.iconscout.com/icon/premium/png-256-thumb/email-2030737-1713377.png' }
  end
end
