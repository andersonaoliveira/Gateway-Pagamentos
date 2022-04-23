FactoryBot.define do
  factory :coupon do
    code { 'NATAL20OFF-XU799' }
    sale_id { 0 }
    status { 0 }
    sale
  end
end
