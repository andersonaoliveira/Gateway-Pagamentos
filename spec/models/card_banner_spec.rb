require 'rails_helper'

RSpec.describe CardBanner, type: :model do
  context 'all fields are mandatory' do
    it 'name is mandatory' do
      card_banner = CardBanner.new(name: '', percentual_tax: 10.0, max_tax: 50, max_instalments: 12, discount: 10.0)

      expect(card_banner).not_to be_valid
    end

    it 'percentual_tax is mandatory' do
      card_banner = CardBanner.new(name: 'MasterCard', percentual_tax: '', max_tax: 50, max_instalments: 12,
                                   discount: 10.0)

      expect(card_banner).not_to be_valid
    end

    it 'max_instalments is mandatory' do
      card_banner = CardBanner.new(name: 'MasterCard', percentual_tax: 10.0, max_tax: 50, max_instalments: '',
                                   discount: 10.0)

      expect(card_banner).not_to be_valid
    end

    it 'max_tax is mandatory' do
      card_banner = CardBanner.new(name: 'MasterCard', percentual_tax: 10.0, max_tax: '', max_instalments: 12,
                                   discount: 10.0)

      expect(card_banner).not_to be_valid
    end

    it 'discount is mandatory' do
      card_banner = CardBanner.new(name: '', percentual_tax: 10.0, max_tax: 50, max_instalments: 12, discount: '')

      expect(card_banner).not_to be_valid
    end
  end

  context 'some attributes must be unique' do
    it 'duplicate name' do
      create(:card_banner)
      card_banner = CardBanner.new(name: 'Visa', percentual_tax: 10.0, max_tax: 50, max_instalments: 12,
                                   discount: 10.0)

      expect(card_banner).not_to be_valid
    end
  end
end
