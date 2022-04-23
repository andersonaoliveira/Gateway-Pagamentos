require 'rails_helper'

describe 'Admin view card banner details' do
  it 'successfuly' do
    admin = create(:admin)
    create :card_banner
    create :card_banner, name: 'Mastercard'

    login_as admin
    visit root_path
    click_on 'Visualizar Bandeira'
    click_on(class: 'Visa')

    expect(page).to have_content 'Visa'
    expect(page).to have_content 'TAXA COBRADA'
    expect(page).to have_content '10,0%'
    expect(page).to have_content 'VALOR MÁXIMO DA TAXA'
    expect(page).to have_content 'R$ 10,00'
    expect(page).to have_content 'NÚMERO MÁXIMO DE PARCELAS'
    expect(page).to have_content '12'
    expect(page).to have_content 'DESCONTO PARA COMPRAS À VISTA'
    expect(page).to have_content '9,0%'
    expect(page).not_to have_content 'Mastercard'
  end

  context 'and change card banner status' do
    it 'disable card banner' do
      admin = create(:admin)
      card_banner = create(:card_banner)
      card_banner.icon = fixture_file_upload(Rails.root.join('spec', 'support', 'icons', 'visa.png'), 'image/png')
      card_banner.save
      login_as(admin)
      visit root_path
      click_on 'Visualizar Bandeira'
      click_on(class: 'Visa')
      click_on 'Desativar'

      expect(current_path).to eq card_banner_path(card_banner.id)
      expect(page).to have_content(card_banner.name)
      expect(page).to have_button('Ativar')
    end

    it 'activate card banner' do
      admin = create(:admin)
      card_banner = create(:card_banner)
      card_banner.icon = fixture_file_upload(Rails.root.join('spec', 'support', 'icons', 'visa.png'), 'image/png')
      card_banner.save
      card_banner.inactive!

      login_as(admin)
      visit root_path
      click_on 'Visualizar Bandeira'
      click_on(class: 'Visa')
      click_on 'Ativar'

      expect(current_path).to eq card_banner_path(card_banner.id)
      expect(page).to have_content(card_banner.name)
      expect(page).to have_button('Desativar')
    end
  end
end
