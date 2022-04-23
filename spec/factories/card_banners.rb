FactoryBot.define do
  factory :card_banner do
    name { 'Visa' }
    max_tax { 10.0 }
    percentual_tax { 10.0 }
    max_instalments { 12 }
    discount { 9.0 }

    before(:create) do |card_banner|
      card_banner.icon.attach(io: File.open(Rails.root.join('spec', 'support',
                                                            'icons',
                                                            "#{card_banner.name.downcase}.png")),
                              filename: "#{card_banner.name.downcase}.png",
                              content_type: 'image/png')
    end
  end
end
