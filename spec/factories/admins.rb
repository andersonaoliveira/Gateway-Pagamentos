# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { 'admin@locaweb.com.br' }
    password { 'admin1' }
  end
end
