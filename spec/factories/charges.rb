FactoryBot.define do
  factory :charge do
    id_order { 1 }
    credit_card_token { 'CAMPUSCODELOCAWEBQSD' }
    qty_instalments { 1 }
    client_eni { '33322233345' }
    product_group_id { 'EMAIL' }
    order_value { 1000.0 }
    cupom_code { '' }
  end
end
