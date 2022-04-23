# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
adm1 = Admin.create!({ email: 'pagamento@locaweb.com.br', password: '123456' })
adm2 = Admin.create!({ email: 'joao@locaweb.com.br', password: '123456' })

visa = CardBanner.create!(name: 'Visa', max_tax: 5.0, percentual_tax: 10.0, max_instalments: 12, discount: 9.0)
visa.icon.attach(io: File.open(Rails.root.join('spec', 'support', 'icons', 'visa.png')), filename: 'visa.png',
                content_type: 'image/png')

mastercard = CardBanner.create!( name: 'Mastercard', max_tax: 10.0, percentual_tax: 10.0, max_instalments: 12, discount: 10.0 )
mastercard.icon.attach(io: File.open(Rails.root.join('spec', 'support', 'icons', 'mastercard.png')), filename: 'mastercard.png',
                      content_type: 'image/png')

elo = CardBanner.create!( name: 'Elo', max_tax: 8.0, percentual_tax: 10.0, max_instalments: 12, discount: 8.0 )
elo.icon.attach(io: File.open(Rails.root.join('spec', 'support', 'icons', 'elo.png')), filename: 'elo.png',
                content_type: 'image/png')

cartao_visa = CreditCard.create!(holder_name: "Cliente 1",
                                 cpf: "33122133315",
                                 card_banner_id: 1,
                                 number: "4441555166612221",
                                 valid_date: '2025-05',
                                 security_code: "719")

cartao_master = CreditCard.create!(holder_name: "Cliente 2",
                                   cpf: "33222233325",
                                   card_banner_id: 2,
                                   number: "4442555266622222",
                                   valid_date: '2025-05',
                                   security_code: "729")

cartao_elo = CreditCard.create!(holder_name: "Cliente 3",
                                cpf: "33322333335",
                                card_banner_id: 3,
                                number: "4443555366632223",
                                valid_date: '2025-05',
                                security_code: "719")

bora_gastar = Sale.create!(name: 'BoraGastar', expiration_date: '12/10/2022',
                           discount: 40, quantity: 10, product_group_id: 1,
                           max_value: 100, admin: adm1, approver: adm2, status: 'approved' )

bora_gastar.generate_coupons
