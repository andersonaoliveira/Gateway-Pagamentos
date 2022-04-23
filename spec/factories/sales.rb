FactoryBot.define do
  factory :sale do
    name { 'NatalIluminado' }
    expiration_date { '25/12/2022' }
    discount { 10 }
    quantity { 100 }
    product_group_id { 'EMAIL' }
    max_value { 200 }
    admin
  end
end
